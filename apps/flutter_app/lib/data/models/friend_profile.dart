/// Represents the public profile of another user.
/// Contains only the data necessary for UI lists (Leaderboards, Friend lists).
class FriendProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int score; 

  const FriendProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.score = 0,
  });

  factory FriendProfile.fromMap(Map<String, dynamic> map) {
    return FriendProfile(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      score: map['score'] ?? 0,
    );
  }

  String get fullName => '$firstName $lastName';
}