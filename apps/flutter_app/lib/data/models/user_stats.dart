class UserStats {
  final String userId;
  final String fullName;
  final int streak;
  final int totalVerses;
  final int masteredVerses;
  final int totalReviews;
  final double averageAccuracy;

  UserStats({
    required this.userId,
    this.fullName = '',
    required this.streak,
    required this.totalVerses,
    this.masteredVerses = 0,
    required this.totalReviews,
    this.averageAccuracy = 0.0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      streak: json['dailyVerseStreak'] ?? 0,
      totalVerses: json['totalVerses'] ?? 0,
      masteredVerses: json['masteredVerses'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}