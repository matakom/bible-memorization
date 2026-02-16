/// Holds stats for HLR spaced repetition algorithm.
class HlrStats {
  final double stability;
  final double difficulty;
  final int correctCount;
  final int incorrectCount;

  const HlrStats({
    required this.stability,
    required this.difficulty,
    required this.correctCount,
    required this.incorrectCount,
  });
  
  // Default values
  factory HlrStats.initial() {
    return const HlrStats(
      stability: 0.0,
      difficulty: 0.0, 
      correctCount: 0,
      incorrectCount: 0,
    );
  }

  factory HlrStats.fromMap(Map<String, dynamic> map) {
    return HlrStats(
      stability: map['calculated_half_life'] ?? 0.0,
      difficulty: map['calculated_difficulty'] ?? 0.0,
      correctCount: map['correct_count'] ?? 0,
      incorrectCount: map['incorrect_count'] ?? 0,
    );
  }
}