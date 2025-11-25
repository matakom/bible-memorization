class UserStats {
  final String userId;
  final String firstName;
  final String lastName;
  final int streak;
  final int totalVerses;
  final int masteredVerses;
  final int totalReviews;
  final int averageAccuracy;

  UserStats({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.streak,
    required this.totalVerses,
    required this.masteredVerses,
    required this.totalReviews,
    required this.averageAccuracy,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      streak: json['streak'] ?? 0,
      totalVerses: json['totalVerses'] ?? 0,
      masteredVerses: json['masteredVerses'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      averageAccuracy: json['averageAccuracy'] ?? 0,
    );
  }
  
  String get fullName => '$firstName $lastName';
}