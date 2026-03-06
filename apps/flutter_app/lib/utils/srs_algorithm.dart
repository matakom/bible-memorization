/// Implementation of the SM-2 Spaced Repetition Algorithm for calculating review intervals.
class SRSAlgorithm {
  static const double defaultEaseFactor = 2.5;
  static const double minEaseFactor = 1.3;

  /// Calculates text complexity based on word count and total character length.
  static double calculateComplexity(String text) {
    if (text.isEmpty) return 0.0;
    final words = text.trim().split(RegExp(r'\s+')).length;
    final complexity = (words * 0.1) + (text.length * 0.01);
    return double.parse(complexity.toStringAsFixed(2));
  }

  /// Determines the starting Ease Factor for a verse based on its calculated complexity.
  static double getInitialEaseFactor(double complexity) {
    final ef = defaultEaseFactor - (complexity * 0.2);
    return ef < minEaseFactor ? minEaseFactor : ef;
  }

  /// Processes a review session to determine the next review date and updated Ease Factor.
  static SRSResult processReview({
    required int currentGrade,
    required double currentEaseFactor,
    required int currentRepetitionCount,
    required DateTime lastReviewDate,
    required DateTime currentNextReviewDate,
  }) {
    double newEaseFactor = currentEaseFactor;
    int newRepetitionCount = currentRepetitionCount;
    DateTime nextDate;

    if (currentGrade >= 3) {
      int intervalDays;
      if (newRepetitionCount == 0) {
        intervalDays = 1;
      } else if (newRepetitionCount == 1) {
        intervalDays = 6;
      } else {
        final prevInterval = currentNextReviewDate.difference(lastReviewDate).inDays;
        intervalDays = ((prevInterval < 1 ? 1 : prevInterval) * currentEaseFactor).ceil();
      }
      nextDate = DateTime.now().add(Duration(days: intervalDays));
      newRepetitionCount++;
    } else {
      newRepetitionCount = 0;
      nextDate = DateTime.now().add(const Duration(days: 1));
    }

    final q = currentGrade;
    newEaseFactor = currentEaseFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
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

  SRSResult({required this.easeFactor, required this.repetitionCount, required this.nextReviewDate});
}