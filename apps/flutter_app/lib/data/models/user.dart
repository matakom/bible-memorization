/// Core application user profile data.
class AppUser {
  final String id;
  final String language;
  final String friendCode;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime registeredAt;

  AppUser({
    required this.id,
    required this.language,
    required this.friendCode,
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.registeredAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      language: json['language'] as String,
      friendCode: json['friendCode'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }
}