/// Represents the user account, gamification status, and global memory parameters.
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  // Assigned by server
  final String friendCode;

  // Gamification
  final int score;

  // HLR Parameters
  final double targetRetention;
  final double userMemoryFactor;

  final String language;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.friendCode,
    required this.score,
    required this.targetRetention,
    required this.userMemoryFactor,
    required this.language,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      friendCode: map['friendCode'] ?? '',
      score: map['score'] ?? 0,
      targetRetention: map['target_retention'] ?? 0.9,
      userMemoryFactor: map['user_memory_factor'] ?? 1.0,
      language: map['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'friendCode': friendCode,
      'score': score,
      'target_retention': targetRetention,
      'user_memory_factor': userMemoryFactor,
      'language': language,
    };
  }
}