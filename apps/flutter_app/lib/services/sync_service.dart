import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;

class SyncService {
  final Dio _dio;
  final db.AppDatabase _db;
  final SharedPreferences _prefs;

  SyncService(this._dio, this._db, this._prefs);

  static const String _kLastSyncKey = 'last_sync_timestamp';

  bool _isSyncing = false;

  /// Main entry point to run synchronization
  Future<void> runSync() async {
    if (_isSyncing) {
      print("⚠️ Sync skipped: Already in progress.");
      return;
    }

    _isSyncing = true;
    print("🔄 SYNC STARTED");

    try {
      // --- STEP 1: PUSH (Client -> Server) ---
      try {
        print("➡️ Attempting PUSH...");
        await _pushChanges();
        print("✅ PUSH Finished");
      } catch (e) {
        // If push fails, log it but DON'T stop. We still want to pull new data.
        print("❌ PUSH FAILED: $e");
      }

      // --- STEP 2: PULL (Server -> Client) ---
      try {
        print("⬅️ Attempting PULL...");
        await _pullChanges();
        print("✅ PULL Finished");
      } catch (e) {
        print("❌ PULL FAILED: $e");
      }
    } catch (e) {
      print("❌ CRITICAL SYNC ERROR: $e");
    } finally {
      _isSyncing = false;
      print("🏁 SYNC COMPLETE");
    }
  }

  // =================================================================
  // 1. PUSH: Client -> Server
  // =================================================================
  Future<void> _pushChanges() async {
    // 1. GATHER DIRTY DATA
    final dirtyVerses = await (_db.select(
      _db.savedVerses,
    )..where((t) => t.needsSync.equals(true))).get();
    final dirtyExercises = await (_db.select(
      _db.exercises,
    )..where((t) => t.needsSync.equals(true))).get();
    final dirtyFriendships = await (_db.select(
      _db.friendships,
    )..where((t) => t.needsSync.equals(true))).get();

    // We expect only 1 user row to be dirty at a time (the current user)
    final dirtyUser = await (_db.select(
      _db.users,
    )..where((t) => t.needsSync.equals(true))).getSingleOrNull();

    // Stop if nothing to sync
    if (dirtyVerses.isEmpty &&
        dirtyExercises.isEmpty &&
        dirtyFriendships.isEmpty &&
        dirtyUser == null) {
      return;
    }

    // 2. BUILD PAYLOAD
    final payload = {
      'verses': dirtyVerses
          .map(
            (v) => {
              'id': v.id,
              'book': v.book,
              'chapter': v.chapter,
              'verse': v.verse,
              'translation': v.translation,
              'text': v.verseText,
              'easeFactor': v.easeFactor,
              'repetitionCount': v.repetitionCount,
              'baseComplexity': v.baseComplexity,
              'nextReviewDate': v.nextReviewDate.toIso8601String(),
              'lastReviewDate': v.lastReviewDate?.toIso8601String(),
              'updatedAt': v.updatedAt.toIso8601String(),
              'deletedAt': v.deletedAt?.toIso8601String(),
            },
          )
          .toList(),

      'exercises': dirtyExercises
          .map(
            (e) => {
              'id': e.id,
              'verseId': e.verseId,
              'grade': e.grade,
              'exerciseType': e.exerciseType,
              'durationSeconds': e.durationSeconds,
              'performedAt': e.performedAt.toIso8601String(),
              'updatedAt': e.updatedAt.toIso8601String(),
              'deletedAt': e.deletedAt?.toIso8601String(),
            },
          )
          .toList(),

      'friendships': dirtyFriendships
          .map(
            (f) => {
              'id': f.id,
              'userId': f.userId,
              'friendId': f.friendId,
              'status': f.status,
              'createdAt': f.createdAt.toIso8601String(),
              'updatedAt': f.updatedAt.toIso8601String(),
              'deletedAt': f.deletedAt?.toIso8601String(),
            },
          )
          .toList(),

      // User Object (Single object, not list)
      'user': dirtyUser != null
          ? {
              'language': dirtyUser.language,
              // Add other syncable user fields here if needed
            }
          : null,
    };

    // 3. SEND TO API
    await _dio.post('/sync/push', data: payload);

    // 4. MARK CLEAN (Explicitly for each table type)

    // Clean Verses
    if (dirtyVerses.isNotEmpty) {
      final ids = dirtyVerses.map((e) => e.id).toList();
      await (_db.update(_db.savedVerses)..where((t) => t.id.isIn(ids))).write(
        const db.SavedVersesCompanion(needsSync: Value(false)),
      );
    }

    // Clean Exercises
    if (dirtyExercises.isNotEmpty) {
      final ids = dirtyExercises.map((e) => e.id).toList();
      await (_db.update(_db.exercises)..where((t) => t.id.isIn(ids))).write(
        const db.ExercisesCompanion(needsSync: Value(false)),
      );
    }

    // Clean Friendships
    if (dirtyFriendships.isNotEmpty) {
      final ids = dirtyFriendships.map((e) => e.id).toList();
      await (_db.update(_db.friendships)..where((t) => t.id.isIn(ids))).write(
        const db.FriendshipsCompanion(needsSync: Value(false)),
      );
    }

    // Clean User
    if (dirtyUser != null) {
      await (_db.update(_db.users)..where((t) => t.id.equals(dirtyUser.id)))
          .write(const db.UsersCompanion(needsSync: Value(false)));
    }
  }

  // =================================================================
  // 2. PULL: Server -> Client
  // =================================================================
  Future<void> _pullChanges() async {
    // A. Get Checkpoint
    final lastSync = _prefs.getString(_kLastSyncKey);

    // B. Call API
    final response = await _dio.get(
      '/sync/pull',
      queryParameters: {if (lastSync != null) 'lastSync': lastSync},
    );

    final data = response.data;
    final serverTimestamp = data['timestamp'];
    final changes = data['changes'];

    // C. Apply Changes to Local DB
    await _db.batch((batch) {
      // 1. VERSES
      if (changes['verses'] != null) {
        for (final v in changes['verses']) {
          if (v['deletedAt'] != null) {
            // Physical Delete
            batch.delete(
              _db.savedVerses,
              db.SavedVersesCompanion(id: Value(v['id'])),
            );
          } else {
            // Upsert
            batch.insert(
              _db.savedVerses,
              _verseFromJson(v),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      }

      // 2. EXERCISES
      if (changes['exercises'] != null) {
        for (final e in changes['exercises']) {
          if (e['deletedAt'] != null) {
            batch.delete(
              _db.exercises,
              db.ExercisesCompanion(id: Value(e['id'])),
            );
          } else {
            batch.insert(
              _db.exercises,
              _exerciseFromJson(e),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      }

      print('-----------------------------');
      print(changes['friendships']);
      print('-----------------------------');

      // 3. FRIENDSHIPS
      if (changes['friendships'] != null) {
        for (final f in changes['friendships']) {
          if (f['deletedAt'] != null) {
            batch.delete(
              _db.friendships,
              db.FriendshipsCompanion(id: Value(f['id'])),
            );
          } else {
            batch.insert(
              _db.friendships,
              _friendshipFromJson(f),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      }

      // 4. USER SETTINGS (New)
      if (changes['user'] != null) {
        for (final u in changes['user']) {
          batch.update(_db.users, _userFromJson(u));
        }
      }
    });

    // D. Update Checkpoint
    if (serverTimestamp != null) {
      await _prefs.setString(_kLastSyncKey, serverTimestamp);
    }
  }

  // --- JSON MAPPERS ---

  db.SavedVersesCompanion _verseFromJson(Map<String, dynamic> json) {
    return db.SavedVersesCompanion.insert(
      id: json['id'],
      book: json['book'],
      chapter: json['chapter'],
      verse: json['verse'],
      translation: json['translation'],
      verseText: json['text'] ?? '',
      easeFactor: Value(json['easeFactor']?.toDouble() ?? 2.5),
      repetitionCount: Value(json['repetitionCount'] ?? 0),
      baseComplexity: Value(json['baseComplexity']?.toDouble() ?? 0.0),
      nextReviewDate: DateTime.parse(json['nextReviewDate']),
      lastReviewDate: Value(
        json['lastReviewDate'] != null
            ? DateTime.parse(json['lastReviewDate'])
            : null,
      ),
      updatedAt: Value(DateTime.parse(json['updatedAt'])),
      deletedAt: const Value(null),
      needsSync: const Value(false),
    );
  }

  db.ExercisesCompanion _exerciseFromJson(Map<String, dynamic> json) {
    return db.ExercisesCompanion.insert(
      id: json['id'],
      verseId: json['verseId'],
      grade: json['grade'],
      exerciseType: json['exerciseType'],
      durationSeconds: json['durationSeconds'],
      performedAt: Value(DateTime.parse(json['performedAt'])),
      updatedAt: Value(DateTime.parse(json['updatedAt'])),
      deletedAt: const Value(null),
      needsSync: const Value(false),
    );
  }

  db.FriendshipsCompanion _friendshipFromJson(Map<String, dynamic> json) {
    return db.FriendshipsCompanion.insert(
      id: json['id'],
      userId: json['userId'],
      friendId: json['friendId'],
      friendFirstName: json['friendFirstName'] ?? 'Unknown',
      friendLastName: json['friendLastName'] ?? '',
      status: json['status'],
      createdAt: Value(DateTime.parse(json['createdAt'])),
      updatedAt: Value(DateTime.parse(json['updatedAt'])),
      deletedAt: const Value(null),
      needsSync: const Value(false),
    );
  }

  db.UsersCompanion _userFromJson(Map<String, dynamic> json) {
    return db.UsersCompanion(
      id: Value(json['id']),
      language: Value(json['language'] ?? 'en'),
      needsSync: const Value(false),
      updatedAt: Value(DateTime.parse(json['updatedAt'])),
    );
  }
}

// Provider
final syncServiceProvider = FutureProvider<SyncService>((ref) async {
  // 1. Get Security Context (for SSL)
  final securityContext = await ref.watch(securityContextFutureProvider.future);

  // 2. Create Dio
  final dio = createDioClient(securityContext, ref);

  // 3. Get Database
  final database = ref.watch(db.databaseProvider);

  // 4. Get Prefs
  final prefs = await SharedPreferences.getInstance();

  return SyncService(dio, database, prefs);
});
