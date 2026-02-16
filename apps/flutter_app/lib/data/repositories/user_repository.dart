import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart' hide User;
import '../local/daos/users_dao.dart';
import '../models/user.dart';

class UserRepository {
  final UsersDao _dao;

  UserRepository(this._dao);

  /// Returns the current user or null if not logged in.
  Future<User?> getCurrentUser() async {
    final row = await _dao.getCurrentUser();
    if (row == null) return null;
    return _mapToDomain(row);
  }

  /// Saves a user
  Future<void> saveUser(User user) async {
    final entry = UsersCompanion(
      id: Value(user.id),
      email: Value(user.email),
      firstName: Value(user.firstName),
      lastName: Value(user.lastName),
      friendCode: Value(user.friendCode),
      score: Value(user.score),
      targetRetention: Value(user.targetRetention),
      userMemoryFactor: Value(user.userMemoryFactor),
      language: Value(user.language),
      updatedAt: Value(DateTime.now()),
    );
    await _dao.saveUser(entry);
  }

  /// Updates local settings.
  Future<void> updateSettings({required String userId, String? language, double? targetRetention}) async {
    await _dao.updateSettings(userId, language: language, targetRetention: targetRetention);
  }

  User _mapToDomain(dynamic row) {
    return User(
      id: row.id,
      firstName: row.firstName,
      lastName: row.lastName,
      email: row.email,
      friendCode: row.friendCode,
      score: row.score,
      targetRetention: row.targetRetention,
      userMemoryFactor: row.userMemoryFactor,
      language: row.language,
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UserRepository(db.usersDao);
});