class FriendUser {
  final String id;
  final String firstName;
  final String lastName;

  FriendUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    return FriendUser(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }
}

class FriendshipData {
  final String id;
  final String status; // 'pending', 'accepted'
  final String direction; // 'sent', 'received'
  final DateTime createdAt;
  final FriendUser user; // The one who SENT the request
  final FriendUser friend; // The one who RECEIVED the request

  FriendshipData({
    required this.id,
    required this.status,
    required this.direction,
    required this.createdAt,
    required this.user,
    required this.friend,
  });

  factory FriendshipData.fromJson(Map<String, dynamic> json) {
    return FriendshipData(
      id: json['id'] as String,
      status: json['status'] as String,
      direction: json['requestDirection'] as String, // Created on server
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: FriendUser.fromJson(json['user'] as Map<String, dynamic>),
      friend: FriendUser.fromJson(json['friend'] as Map<String, dynamic>),
    );
  }
}