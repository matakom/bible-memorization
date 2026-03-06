import 'package:flutter_app/data/local/app_database.dart' as db;

/// Local representation of a friendship mapped from the database entity.
class Friendship {
  final String id;
  final String userId;
  final String friendId;
  final String friendFirstName;
  final String friendLastName;
  final String status;

  Friendship({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendFirstName,
    required this.friendLastName,
    required this.status,
  });

  factory Friendship.fromEntity(db.Friendship entity) {
    return Friendship(
      id: entity.id,
      userId: entity.userId,
      friendId: entity.friendId,
      friendFirstName: entity.friendFirstName,
      friendLastName: entity.friendLastName,
      status: entity.status,
    );
  }
}