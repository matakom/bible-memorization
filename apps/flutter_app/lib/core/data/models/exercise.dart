class Exercise {
  Exercise({
    required this.id,
    required this.userId,
    required this.savedVerseId,
    required this.durationSeconds,
    required this.performedAt,
    required this.success,
    required this.exerciseType,
  });

  factory Exercise.fromJson(Map<String, Object?> json) {
    return Exercise(
      id: json['id']! as int,
      userId: json['user_id']! as int,
      savedVerseId: json['saved_verse_id']! as int,
      durationSeconds: json['duration_seconds']! as int,
      performedAt: DateTime.parse(json['performed_at']! as String),
      success: json['success']! as bool,
      exerciseType: json['exercise_type']! as String,
    );
  }

  final int id;
  final int userId;
  final int savedVerseId;
  final int durationSeconds;
  final DateTime performedAt;
  final bool success;
  final String exerciseType;
}