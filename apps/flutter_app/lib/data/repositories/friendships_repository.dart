import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart' hide Friendship;
import '../local/daos/friendships_dao.dart';
import '../local/enums.dart';
import '../models/friendship.dart';
import '../models/friend_profile.dart';

class FriendshipRepository {
  final FriendshipsDao _dao;

  FriendshipRepository(this._dao);

  Future<List<Friendship>> getFriendships() async {
    final rows = await _dao.getAllFriendships();
    
    return rows.map((row) {
      return Friendship(
        id: row.id,
        status: row.status,
        isOutgoing: row.isOutgoing,
        createdAt: row.createdAt,
        
        // Build the nested profile
        friend: FriendProfile(
          id: row.friendId,
          firstName: row.friendFirstName,
          lastName: row.friendLastName,
          score: row.friendScore,
        ),
      );
    }).toList();
  }

  Future<void> acceptRequest(String friendshipId) async {
    await _dao.updateStatus(friendshipId, FriendshipStatus.accepted);
  }

  Future<void> rejectOrDelete(String friendshipId) async {
    await _dao.deleteFriendship(friendshipId);
  }
}

final friendshipRepositoryProvider = Provider<FriendshipRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FriendshipRepository(db.friendshipsDao);
});