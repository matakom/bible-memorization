import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users.dart';
import '../tables/deleted_items.dart';
import '../tables/saved_verses.dart';
import '../tables/exercises.dart';
import '../tables/friendships.dart';
import '../enums.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users, SavedVerses, Exercises, Friendships, DeletedItems])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Gets the currently logged-in user.
  Future<User?> getCurrentUser() {
    return select(users).getSingleOrNull();
  }

  /// Inserts or Updates the user.
  /// Used during Login or Sync.
  Future<void> saveUser(UsersCompanion entry) {
    return into(users).insertOnConflictUpdate(entry);
  }

  /// Updates specific settings like Language or Algorithm parameters.
  Future<void> updateSettings(String userId, {String? language, double? targetRetention}) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        language: language != null ? Value(language) : const Value.absent(),
        targetRetention: targetRetention != null ? Value(targetRetention) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true)
      ),
    );
  }

  /// Updates the score.
  Future<void> updateScore(String userId, int newScore) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        score: Value(newScore),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteUserAccount(String userId) {
    return transaction(() async {
      await into(deletedItems).insert(
        DeletedItemsCompanion.insert(
          itemId: userId,
          resourceType: DeleteResourceType.user, 
        ),
      );

      await delete(exercises).go();
      await delete(savedVerses).go();
      await delete(friendships).go();
      
      await (delete(users)..where((t) => t.id.equals(userId))).go();
    });
  }

  Stream<User?> watchCurrentUser() {
    return select(users).watchSingleOrNull();
  }

}