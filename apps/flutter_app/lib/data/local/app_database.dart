import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import Tables
import 'tables/local_bible_verses.dart';
import 'tables/saved_verses.dart';
import 'tables/exercises.dart';
import 'tables/users.dart';
import 'tables/friendships.dart';
import 'tables/deleted_items.dart';
import 'tables/bible_books.dart';

// Import DAOs
import 'daos/bible_dao.dart';
import 'daos/saved_verses_dao.dart';
import 'daos/friendships_dao.dart';
import 'daos/exercises_dao.dart';
import 'daos/users_dao.dart';

import './enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalBibleVerses, 
    SavedVerses, 
    Exercises, 
    Friendships, 
    Users,
    DeletedItems,
    BibleBooks
  ],
  daos: [
    BibleDao,
    SavedVersesDao,
    FriendshipsDao,
    ExercisesDao,
    UsersDao
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  Future<void> clearAllData() {
    return transaction(() async {
      await delete(exercises).go();
      await delete(savedVerses).go();
      await delete(friendships).go();
      await delete(users).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bible_memory.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});