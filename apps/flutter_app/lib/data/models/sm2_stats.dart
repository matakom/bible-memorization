/// Holds stats for SM2 spaced repetition algorithm.
class Sm2Stats {
  final double easeFactor;
  final int intervalDays;
  final int repetitionCount;

  const Sm2Stats({
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitionCount,
  });

  // Default starting values for a new verse
  factory Sm2Stats.initial() {
    return const Sm2Stats(
      easeFactor: 2.5, // Default
      intervalDays: 0,
      repetitionCount: 0,
    );
  }

  factory Sm2Stats.fromMap(Map<String, dynamic> map) {
    return Sm2Stats(
      easeFactor: map['ease_factor'] ?? 2.5,
      intervalDays: map['interval_days'] ?? 0,
      repetitionCount: map['repetition_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'repetition_count': repetitionCount,
    };
  }
}