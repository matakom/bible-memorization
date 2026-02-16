import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/friendships.dart';
import '../enums.dart';
import '../tables/deleted_items.dart';

part 'friendships_dao.g.dart';

@DriftAccessor(tables: [Friendships, DeletedItems])
class FriendshipsDao extends DatabaseAccessor<AppDatabase> with _$FriendshipsDaoMixin {
  FriendshipsDao(super.db);

  Future<List<Friendship>> getAllFriendships() {
    return (select(friendships)
      ..orderBy([(t) => OrderingTerm(expression: t.friendFirstName)])) // Alphabetical
      .get();
  }

  Future<void> updateStatus(String id, FriendshipStatus newStatus) {
    return (update(friendships)..where((t) => t.id.equals(id))).write(
      FriendshipsCompanion(
        status: Value(newStatus),
        needsSync: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> insertFriendship(FriendshipsCompanion entry) {
    return into(friendships).insert(entry);
  }

  Future<void> deleteFriendship(String id) {
    return transaction(() async {
      await into(deletedItems).insert(
        DeletedItemsCompanion.insert(
          itemId: id,
          resourceType: DeleteResourceType.friendship,
        ),
      );

      await (delete(friendships)..where((t) => t.id.equals(id))).go();
    });
  }
}