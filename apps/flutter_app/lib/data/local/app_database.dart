import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SavedVerses, Exercises, Friendships, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // QUERIES
  Future<List<SavedVerse>> getAllVerses() {
    return (select(savedVerses)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.nextReviewDate)]))
        .get();
  }

  Future<List<SavedVerse>> getDueVerses() {
    final now = DateTime.now();
    return (select(savedVerses)
          ..where((t) => t.deletedAt.isNull())
          ..where((t) => t.nextReviewDate.isSmallerOrEqualValue(now)))
        .get();
  }

  Future<List<Friendship>> getMyFriendships(String myUserId) {
    return (select(friendships)
          ..where(
            (t) => t.userId.equals(myUserId) | t.friendId.equals(myUserId),
          )
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  Future<int> updateUserLanguage(String userId, String languageCode) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        language: Value(languageCode),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(exercises).go();
      await delete(friendships).go();
      await delete(savedVerses).go();
      await delete(users).go();
    });
  }

  Future<int> calculateLocalStreak() async {
    final history = await (select(exercises)
          ..orderBy([
            (t) => OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)
          ]))
        .get();

    if (history.isEmpty) return 0;

    int streak = 0;
    
    DateTime toDate(DateTime d) => DateTime(d.year, d.month, d.day);

    final today = toDate(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    
    final practiceDates = history.map((e) => toDate(e.performedAt)).toSet();

    if (!practiceDates.contains(today) && !practiceDates.contains(yesterday)) {
      return 0;
    }

    DateTime checkDate = practiceDates.contains(today) ? today : yesterday;

    while (practiceDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
