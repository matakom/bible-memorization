import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/friendship.dart';
import 'package:flutter_app/data/repositories/friendships_repository.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;

/// Manages the local state of friendships by reading directly from the database and 
/// delegating actions to the repository.
class FriendshipsNotifier extends AsyncNotifier<List<Friendship>> {
  @override
  Future<List<Friendship>> build() async {
    final database = ref.watch(db.databaseProvider);
    
    try {
      final rows = await (database.select(database.friendships)
            ..where((t) => t.deletedAt.isNull()))
          .get();
      return rows.map((row) => Friendship.fromEntity(row)).toList();
    } catch (e) {
      throw Exception('Failed to load local friendships: $e');
    }
  }

  Future<void> addFriendship(String friendCode) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.sendFriendshipRequest(friendCode);
    ref.invalidateSelf();
  }

  Future<void> acceptFriendship(String friendshipId) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.acceptFriendship(friendshipId);
    ref.invalidateSelf();
  }

  Future<void> deleteFriendship(String friendshipId) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.deleteFriendship(friendshipId);
    ref.invalidateSelf();
  }
}

final friendshipsProvider = AsyncNotifierProvider<FriendshipsNotifier, List<Friendship>>(() {
  return FriendshipsNotifier();
});