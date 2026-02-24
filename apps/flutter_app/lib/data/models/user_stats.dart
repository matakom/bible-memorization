class UserStats {
  final String userId;
  final String fullName;
  final int streak;
  final int totalPractices;
  final int memorizedVerses;
  final int timeSpentSeconds;
  final int score;

  UserStats({
    required this.userId,
    required this.fullName,
    required this.streak,
    required this.totalPractices,
    required this.memorizedVerses,
    required this.timeSpentSeconds,
    required this.score,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      streak: json['dailyVerseStreak'] ?? 0,
      totalPractices: json['totalPractices'] ?? 0,
      memorizedVerses: json['memorizedVerses'] ?? 0,
      timeSpentSeconds: json['timeSpentSeconds'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}