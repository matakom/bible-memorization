class Friendship {
  Friendship({
    required this.id,
    required this.status,
    required this.userId,
    required this.friendId,
    required this.createdAt,
  });

  factory Friendship.fromJson(Map<String, Object?> json) {
    return Friendship(
      id: json['id']! as int,
      status: json['status']! as String,
      userId: json['user_id']! as int,
      friendId: json['friend_id']! as int,
      createdAt: DateTime.parse(json['created_at']! as String),
    );
  }

  final int id;
  final String status;
  final int userId;
  final int friendId;
  final DateTime createdAt;
}