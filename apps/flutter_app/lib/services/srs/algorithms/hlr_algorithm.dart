import '../srs_types.dart';
import '../../../data/models/sm2_stats.dart';
import '../../../data/models/hlr_stats.dart';

class HlrAlgorithm implements SrsAlgorithm {
  @override
  SrsUpdateResult calculateProgress({
    required Sm2Stats currentSm2,
    required HlrStats? currentHlr,
    required int grade,
  }) {
    // 1. Initialize HLR stats if this is the first time running HLR
    final hlrBase = currentHlr ?? HlrStats.initial();

    // 2. Calculate new HLR values
    final newHlr = _calculateMath(hlrBase, grade);

    // 3. Determine Next Review Date based on Half-Life (Probability 0.5)
    // Formula: interval = -half_life * log2(probability)
    // If we want review when recall probability drops to 50%:
    // interval = stability * 1.0
    final daysUntilReview = newHlr.stability.round();
    
    // Ensure at least 1 day if stability is low but user was correct
    final nextInterval = (daysUntilReview < 1) ? 1 : daysUntilReview;
    final nextDate = DateTime.now().add(Duration(days: nextInterval));

    return SrsUpdateResult(
      nextReviewDate: nextDate,
      sm2Stats: currentSm2, // Pass through SM2 unchanged
      hlrStats: newHlr,
    );
  }

  HlrStats _calculateMath(HlrStats current, int grade) {
    // Simplified Half-Life Regression Logic
    final isCorrect = grade >= 3;
    
    // Stability Update (How long memory lasts)
    double newStability = current.stability;
    if (isCorrect) {
      // Increase stability (memory gets stronger)
      // Simple factor multiplier for now. Real HLR uses a matrix.
      double factor = 1.0 + (grade == 4 ? 1.5 : 1.0); 
      newStability = (current.stability == 0 ? 1.0 : current.stability) * factor;
    } else {
      // Reset stability on fail (or decrease significantly)
      newStability = 0.5; 
    }

    // Difficulty Update
    // 1 (Forgot) -> Harder (+0.2)
    // 4 (Easy)   -> Easier (-0.2)
    double newDifficulty = current.difficulty - ((grade - 3) * 0.2);
    if (newDifficulty < 0) newDifficulty = 0;
    if (newDifficulty > 10) newDifficulty = 10;

    return HlrStats(
      stability: newStability,
      difficulty: newDifficulty,
      correctCount: current.correctCount + (isCorrect ? 1 : 0),
      incorrectCount: current.incorrectCount + (isCorrect ? 0 : 1),
    );
  }
}