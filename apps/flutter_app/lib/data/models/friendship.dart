import '../local/enums.dart';
import 'friend_profile.dart';

/// Represents a relationship between the current user and another user.
class Friendship {
  final String id;
  
  /// 'pending', 'accepted', 'rejected'
  final FriendshipStatus status;
  
  final FriendProfile friend;
  final bool isOutgoing;
  final DateTime createdAt;

  const Friendship({
    required this.id,
    required this.status,
    required this.friend,
    required this.isOutgoing,
    required this.createdAt,
  });

  factory Friendship.fromMap(Map<String, dynamic> map, int currentUserId) {
    final bool isMeInitiator = map['user_id'] == currentUserId;

    return Friendship(
      id: map['id'],
      status: FriendshipStatus.values.firstWhere(
        (e) => e.name == map['statsu'],
        orElse: () => FriendshipStatus.pending
      ),
      createdAt: DateTime.parse(map['created_at']),
      isOutgoing: isMeInitiator,
      friend: FriendProfile.fromMap(map['friend_profile']),
    );
  }
}