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
    // Helper function to safely parse ints even if the server sends a String
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return UserStats(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      streak: parseInt(json['streak']),
      totalPractices: parseInt(json['totalPractices']),
      memorizedVerses: parseInt(json['memorizedVerses']),
      timeSpentSeconds: parseInt(json['timeSpentSeconds']),
      score: parseInt(json['score']),
    );
  }
}