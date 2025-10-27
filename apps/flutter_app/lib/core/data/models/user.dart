class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dailyVerseOrder,
    required this.language,
    required this.theme,
    required this.registeredAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      id: json['id']! as int,
      firstName: json['first_name']! as String,
      lastName: json['last_name']! as String,
      email: json['email']! as String,
      dailyVerseOrder: json['daily_verse_order']! as int,
      language: json['language']! as String,
      theme: json['theme']! as String,
      registeredAt: DateTime.parse(json['registered_at']! as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at']! as String),
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int dailyVerseOrder;
  final String language;
  final String theme;
  final DateTime registeredAt;
  final DateTime? lastLoginAt;
}
