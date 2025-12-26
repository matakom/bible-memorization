class SRSAlgorithm {
  // Constants for SM-2
  static const double defaultEaseFactor = 2.5;
  static const double minEaseFactor = 1.3;

  /// Calculates static complexity based on text.
  /// Mirrored from NestJS: (words * 0.1) + (length * 0.01)
  static double calculateComplexity(String text) {
    if (text.isEmpty) return 0.0;
    
    final words = text.trim().split(RegExp(r'\s+')).length;
    final length = text.length;

    final complexity = (words * 0.1) + (length * 0.01);
    // Round to 2 decimal places
    return double.parse(complexity.toStringAsFixed(2));
  }

  /// Calculates the initial Ease Factor based on complexity.
  /// Harder verses start with a lower EF so they repeat more often.
  static double getInitialEaseFactor(double complexity) {
    // Formula: 2.5 - (complexity * 0.2)
    // Floor is 1.3
    final ef = defaultEaseFactor - (complexity * 0.2);
    return ef < minEaseFactor ? minEaseFactor : ef;
  }

  /// Calculates the next review data based on the grade (0-5)
  /// Returns a map with the new state.
  static SRSResult processReview({
    required int currentGrade, // 0-5
    required double currentEaseFactor,
    required int currentRepetitionCount,
    required DateTime lastReviewDate,
    required DateTime currentNextReviewDate,
  }) {
    double newEaseFactor = currentEaseFactor;
    int newRepetitionCount = currentRepetitionCount;
    DateTime nextDate;

    if (currentGrade >= 3) {
      // --- SUCCESS ---
      
      // 1. Calculate Interval
      int intervalDays;
      if (newRepetitionCount == 0) {
        intervalDays = 1;
      } else if (newRepetitionCount == 1) {
        intervalDays = 6;
      } else {
        // Interval = (Now - LastReview) * EF
        // We calculate the *actual* interval based on when they *should* have reviewed it vs now.
        // Simplified: use scheduled interval * EF
        final prevInterval = currentNextReviewDate.difference(lastReviewDate).inDays;
        // Ensure strictly positive interval
        final safePrevInterval = prevInterval < 1 ? 1 : prevInterval; 
        intervalDays = (safePrevInterval * currentEaseFactor).ceil();
      }

      nextDate = DateTime.now().add(Duration(days: intervalDays));
      newRepetitionCount++;

      // 2. Update Ease Factor
      // EF' = EF + (0.1 - (5-q) * (0.08 + (5-q)*0.02))
      final q = currentGrade;
      newEaseFactor = currentEaseFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
      
    } else {
      // --- FAILURE ---
      newRepetitionCount = 0;
      nextDate = DateTime.now().add(const Duration(days: 1)); // Review tomorrow
      
      // EF drops (same formula)
      final q = currentGrade;
      newEaseFactor = currentEaseFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    }

    // Safety Floor
    if (newEaseFactor < minEaseFactor) newEaseFactor = minEaseFactor;

    return SRSResult(
      easeFactor: newEaseFactor,
      repetitionCount: newRepetitionCount,
      nextReviewDate: nextDate,
    );
  }
}

class SRSResult {
  final double easeFactor;
  final int repetitionCount;
  final DateTime nextReviewDate;

  SRSResult({
    required this.easeFactor,
    required this.repetitionCount,
    required this.nextReviewDate,
  });
}