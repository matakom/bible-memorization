/// Represents basic profile information for a user within the social system.
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

/// Detailed friendship record including status, request direction, and participant data.
class FriendshipData {
  final String id;
  final String status; 
  final String direction; 
  final DateTime createdAt;
  final FriendUser user; 
  final FriendUser friend; 

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
      direction: json['requestDirection'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: FriendUser.fromJson(json['user'] as Map<String, dynamic>),
      friend: FriendUser.fromJson(json['friend'] as Map<String, dynamic>),
    );
  }
}