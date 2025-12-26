import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/friendship.dart';
import 'package:flutter_app/data/repositories/friendships_repository.dart';

class FriendshipsNotifier extends AsyncNotifier<List<Friendship>> {
  @override
  Future<List<Friendship>> build() async {
    final repository = await ref.watch(friendshipsRepositoryProvider.future);
    return repository.getFriendships();
  }

  /// Adds a friend and then automatically refetches the list.
  Future<void> addFriendship(String friendCode) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.sendFriendshipRequest(friendCode);
    
    // If successful, invalidate this provider to refetch the list
    ref.invalidateSelf();
  }

  /// Accepts a friend request and then automatically refetches the list.
  Future<void> acceptFriendship(String friendshipId) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.acceptFriendship(friendshipId);
    ref.invalidateSelf();
  }

  /// Deletes a friend and then automatically refetches the list.
  Future<void> deleteFriendship(String friendshipId) async {
    final repository = await ref.read(friendshipsRepositoryProvider.future);
    await repository.deleteFriendship(friendshipId);
    ref.invalidateSelf();
  }
}

final friendshipsProvider =
    AsyncNotifierProvider<FriendshipsNotifier, List<Friendship>>(() {
  return FriendshipsNotifier();
});