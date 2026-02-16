import '../srs_types.dart';
import '../../../data/models/sm2_stats.dart';
import '../../../data/models/hlr_stats.dart';

class Sm2Algorithm implements SrsAlgorithm {
  @override
  SrsUpdateResult calculateProgress({
    required Sm2Stats currentSm2,
    required HlrStats? currentHlr,
    required int grade,
  }) {
    // 1. Calculate new SM-2 values
    final newSm2 = _calculateMath(currentSm2, grade);

    // 2. Determine Next Review Date based on SM-2 interval
    final nextDate = DateTime.now().add(Duration(days: newSm2.intervalDays));

    // 3. Return result (Preserving existing HLR stats without touching them)
    return SrsUpdateResult(
      nextReviewDate: nextDate,
      sm2Stats: newSm2,
      hlrStats: currentHlr, 
    );
  }

  Sm2Stats _calculateMath(Sm2Stats current, int grade) {
    int newInterval;
    int newReps;
    double newEase = current.easeFactor;

    if (grade >= 3) {
      // Correct (3=Good, 4=Easy)
      if (current.repetitionCount == 0) {
        newInterval = 1;
      } else if (current.repetitionCount == 1) {
        newInterval = 6;
      } else {
        newInterval = (current.intervalDays * current.easeFactor).round();
      }
      newReps = current.repetitionCount + 1;

      // Adjust Ease Factor (Standard Anki Formula)
      newEase = current.easeFactor + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    } else {
      // Incorrect (1=Again, 2=Hard)
      newReps = 0;
      newInterval = 1;
      // Note: We keep ease factor stable on failure to avoid "Ease Hell"
    }

    // Safety Bounds
    if (newEase < 1.3) newEase = 1.3;

    return Sm2Stats(
      easeFactor: newEase,
      intervalDays: newInterval,
      repetitionCount: newReps,
    );
  }
}