import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'dart:convert';
import '../providers/core/dio_provider.dart';

/// Manages the bidirectional synchronization of verses, exercises, and friendships between local storage and the server.
class SyncService {
  final Dio _dio;
  final db.AppDatabase _db;
  final SharedPreferences _prefs;

  SyncService(this._dio, this._db, this._prefs);

  static const String _kLastSyncKey = 'last_sync_timestamp';

  Future<bool> runSync() async {
    try {
      await _pushChanges();
      await _pullChanges();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _pushChanges() async {
    final dirtyVerses = await (_db.select(_db.savedVerses)..where((t) => t.needsSync.equals(true))).get();
    final dirtyExercises = await (_db.select(_db.exercises)..where((t) => t.needsSync.equals(true))).get();
    final dirtyFriendships = await (_db.select(_db.friendships)..where((t) => t.needsSync.equals(true))).get();
    final dirtyUser = await (_db.select(_db.users)..where((t) => t.needsSync.equals(true))).getSingleOrNull();

    if (dirtyVerses.isEmpty && dirtyExercises.isEmpty && dirtyFriendships.isEmpty && dirtyUser == null) return;

    final payload = {
      'verses': dirtyVerses.map((v) => {
        'id': v.id, 'book': v.book, 'chapter': v.chapter, 'verse': v.verse,
        'translation': v.translation, 'text': v.verseText, 'easeFactor': v.easeFactor,
        'repetitionCount': v.repetitionCount, 'baseComplexity': v.baseComplexity,
        'nextReviewDate': v.nextReviewDate.toIso8601String(),
        'lastReviewDate': v.lastReviewDate?.toIso8601String(),
        'updatedAt': v.updatedAt.toIso8601String(),
        'deletedAt': v.deletedAt?.toIso8601String(),
      }).toList(),
      'exercises': dirtyExercises.map((e) => {
        'id': e.id, 'verseId': e.verseId, 'grade': e.grade, 'exerciseType': e.exerciseType.name,
        'durationSeconds': e.durationSeconds, 'performedAt': e.performedAt.toIso8601String(),
        'updatedAt': e.updatedAt.toIso8601String(), 'deletedAt': e.deletedAt?.toIso8601String(),
      }).toList(),
      'friendships': dirtyFriendships.map((f) => {
        'id': f.id, 'userId': f.userId, 'friendId': f.friendId, 'status': f.status,
        'updatedAt': f.updatedAt.toIso8601String(), 'deletedAt': f.deletedAt?.toIso8601String(),
      }).toList(),
      'user': dirtyUser != null ? {'language': dirtyUser.language} : null,
    };

    await _dio.post('/sync/push', data: payload);

    if (dirtyVerses.isNotEmpty) {
      await (_db.update(_db.savedVerses)..where((t) => t.id.isIn(dirtyVerses.map((e) => e.id).toList())))
          .write(const db.SavedVersesCompanion(needsSync: Value(false)));
    }
    if (dirtyExercises.isNotEmpty) {
      await (_db.update(_db.exercises)..where((t) => t.id.isIn(dirtyExercises.map((e) => e.id).toList())))
          .write(const db.ExercisesCompanion(needsSync: Value(false)));
    }
    if (dirtyFriendships.isNotEmpty) {
      await (_db.update(_db.friendships)..where((t) => t.id.isIn(dirtyFriendships.map((e) => e.id).toList())))
          .write(const db.FriendshipsCompanion(needsSync: Value(false)));
    }
    if (dirtyUser != null) {
      await (_db.update(_db.users)..where((t) => t.id.equals(dirtyUser.id)))
          .write(const db.UsersCompanion(needsSync: Value(false)));
    }
  }

  Future<void> _pullChanges() async {
    final lastSync = _prefs.getString(_kLastSyncKey);
    final response = await _dio.get('/sync/pull', queryParameters: {if (lastSync != null) 'lastSync': lastSync});
    final data = response.data;
    final changes = data['changes'];

    await _db.transaction(() async {
      if (changes['verses'] != null) {
        for (final v in changes['verses']) {
          if (v['deletedAt'] != null) {
            await (_db.delete(_db.savedVerses)..where((tbl) => tbl.id.equals(v['id']))).go();
          } else {
            await _db.into(_db.savedVerses).insert(_verseFromJson(v), mode: InsertMode.insertOrReplace);
          }
        }
      }
      if (changes['exercises'] != null) {
        for (final e in changes['exercises']) {
          if (e['deletedAt'] != null) {
            await (_db.delete(_db.exercises)..where((tbl) => tbl.id.equals(e['id']))).go();
          } else {
            await _db.into(_db.exercises).insert(_exerciseFromJson(e), mode: InsertMode.insertOrReplace);
          }
        }
      }
      if (changes['friendships'] != null) {
        for (final f in changes['friendships']) {
          if (f['deletedAt'] != null) {
            await (_db.delete(_db.friendships)..where((tbl) => tbl.id.equals(f['id']))).go();
          } else {
            await _db.into(_db.friendships).insert(_friendshipFromJson(f), mode: InsertMode.insertOrReplace);
          }
        }
      }
      if (changes['user'] != null && (changes['user'] as List).isNotEmpty) {
        for (final u in changes['user']) {
          await (_db.update(_db.users)..where((tbl) => tbl.id.equals(u['id']))).write(_userFromJson(u));
          final cachedUserStr = _prefs.getString('cached_user_profile');
          if (cachedUserStr != null) {
            try {
              final cachedUser = json.decode(cachedUserStr) as Map<String, dynamic>;
              if (u['firstName'] != null) cachedUser['firstName'] = u['firstName'];
              if (u['lastName'] != null) cachedUser['lastName'] = u['lastName'];
              if (u['friendCode'] != null) cachedUser['friendCode'] = u['friendCode'];
              if (u['language'] != null) cachedUser['language'] = u['language'];
              await _prefs.setString('cached_user_profile', json.encode(cachedUser));
            } catch (_) {}
          }
        }
      }
    });

    if (data['timestamp'] != null) await _prefs.setString(_kLastSyncKey, data['timestamp']);
  }

  db.SavedVersesCompanion _verseFromJson(Map<String, dynamic> json) => db.SavedVersesCompanion.insert(
    id: json['id'], book: json['book'], chapter: json['chapter'], verse: json['verse'],
    translation: json['translation'], verseText: json['text'] ?? '',
    easeFactor: Value(json['easeFactor']?.toDouble() ?? 2.5),
    repetitionCount: Value(json['repetitionCount'] ?? 0),
    baseComplexity: Value(json['baseComplexity']?.toDouble() ?? 0.0),
    nextReviewDate: DateTime.parse(json['nextReviewDate']),
    lastReviewDate: Value(json['lastReviewDate'] != null ? DateTime.parse(json['lastReviewDate']) : null),
    updatedAt: Value(DateTime.parse(json['updatedAt'])), deletedAt: const Value(null), needsSync: const Value(false),
  );

  db.ExercisesCompanion _exerciseFromJson(Map<String, dynamic> json) => db.ExercisesCompanion.insert(
    id: json['id'], verseId: json['verseId'], grade: json['grade'],
    exerciseType: GameType.values.firstWhere((e) => e.name == json['exerciseType'], orElse: () => GameType.flashcard),
    durationSeconds: json['durationSeconds'], performedAt: Value(DateTime.parse(json['performedAt'])),
    updatedAt: Value(DateTime.parse(json['updatedAt'])), deletedAt: const Value(null), needsSync: const Value(false),
  );

  db.FriendshipsCompanion _friendshipFromJson(Map<String, dynamic> json) => db.FriendshipsCompanion.insert(
    id: json['id'], userId: json['userId'], friendId: json['friendId'],
    friendFirstName: json['friendFirstName'] ?? 'Unknown', friendLastName: json['friendLastName'] ?? '',
    status: json['status'], updatedAt: Value(json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now()),
    deletedAt: const Value(null), needsSync: const Value(false),
  );

  db.UsersCompanion _userFromJson(Map<String, dynamic> json) => db.UsersCompanion(
    id: Value(json['id']),
    firstName: json.containsKey('firstName') ? Value(json['firstName']) : const Value.absent(),
    lastName: json.containsKey('lastName') ? Value(json['lastName']) : const Value.absent(),
    friendCode: json.containsKey('friendCode') ? Value(json['friendCode']) : const Value.absent(),
    language: json.containsKey('language') ? Value(json['language']) : const Value.absent(),
    needsSync: const Value(false),
    updatedAt: json.containsKey('updatedAt') ? Value(DateTime.parse(json['updatedAt'])) : const Value.absent(),
  );
}

final syncServiceProvider = FutureProvider<SyncService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final database = ref.watch(db.databaseProvider);
  final prefs = await SharedPreferences.getInstance();
  return SyncService(dio, database, prefs);
});