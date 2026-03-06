import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/models/user_stats.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import '../../providers/core/dio_provider.dart';

/// Aggregates learning metrics and streaks from local and remote data sources.
class StatsRepository {
  final Dio _dio;
  final db.AppDatabase _db;
  final SharedPreferences _prefs;

  StatsRepository(this._dio, this._db, this._prefs);

  Future<UserStats> getMyStats() async {
    String? fullName;

    final dbUser = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    if (dbUser != null) {
      fullName = "${dbUser.firstName} ${dbUser.lastName}";
    }

    if (fullName == null) {
      final cachedUser = _prefs.getString('cached_user_profile');
      if (cachedUser != null) {
        try {
          final user = AppUser.fromJson(json.decode(cachedUser));
          fullName = "${user.firstName} ${user.lastName}";
        } catch (_) {}
      }
    }

    fullName ??= FirebaseAuth.instance.currentUser?.displayName;
    fullName ??= "Host";

    final aggregateQuery = await _db.customSelect('''
      SELECT 
        COUNT(id) AS total_practices,
        COALESCE(SUM(duration_seconds), 0) AS time_spent,
        (COUNT(DISTINCT DATE(performed_at, 'localtime')) * 5) + 
        COALESCE(SUM(CASE WHEN grade >= 3 THEN 3 ELSE 1 END), 0) AS score
      FROM exercises
    ''').getSingle();

    final totalPractices = aggregateQuery.read<int>('total_practices');
    final timeSpentSeconds = aggregateQuery.read<int>('time_spent');
    final score = aggregateQuery.read<int>('score');

    final memorizedQuery = await _db.customSelect('''
      SELECT COUNT(*) as memorized_count FROM (
        SELECT verse_id, grade
        FROM exercises e1
        WHERE performed_at = (
          SELECT MAX(performed_at)
          FROM exercises e2
          WHERE e1.verse_id = e2.verse_id
        )
      ) WHERE grade >= 3
    ''').getSingle();
    
    final memorizedVerses = memorizedQuery.read<int>('memorized_count');

    final datesQuery = await _db.customSelect('''
      SELECT DISTINCT DATE(performed_at, 'unixepoch', 'localtime') as practice_date
      FROM exercises
      WHERE practice_date IS NOT NULL
      ORDER BY practice_date DESC
    ''').get();

    int currentStreak = 0;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    List<DateTime> practiceDates = [];
    for (var row in datesQuery) {
      final dateStr = row.read<String?>('practice_date');
      if (dateStr != null && dateStr.contains('-')) {
        final parts = dateStr.split('-');
        practiceDates.add(DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])));
      }
    }

    if (practiceDates.isNotEmpty) {
      if (practiceDates.contains(today) || practiceDates.contains(yesterday)) {
        DateTime checkDate = practiceDates.contains(today) ? today : yesterday;
        for (var date in practiceDates) {
          if (date == checkDate) {
            currentStreak++;
            checkDate = checkDate.subtract(const Duration(days: 1));
          } else if (date.isBefore(checkDate)) {
            break; 
          }
        }
      }
    }

    return UserStats(
      userId: dbUser?.id ?? FirebaseAuth.instance.currentUser?.uid ?? 'me',
      fullName: fullName,
      streak: currentStreak,
      totalPractices: totalPractices,
      memorizedVerses: memorizedVerses,
      timeSpentSeconds: timeSpentSeconds, 
      score: score,
    );
  }

  Stream<UserStats> watchMyStats() {
    return _db.customSelect('SELECT 1', readsFrom: {_db.savedVerses, _db.exercises}).watch().asyncMap((_) => getMyStats());
  }

  Future<UserStats> getFriendStats(String userId) async {
    try {
      final response = await _dio.get('/user/$userId/stats');
      return UserStats.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load friend stats: $e');
    }
  }
}

final statsRepositoryProvider = FutureProvider((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final database = ref.watch(db.databaseProvider);
  final prefs = await SharedPreferences.getInstance();
  return StatsRepository(dio, database, prefs);
});

final myStatsProvider = StreamProvider<UserStats>((ref) async* {
  final repo = await ref.watch(statsRepositoryProvider.future);
  yield* repo.watchMyStats();
});

final friendStatsProvider = FutureProvider.family<UserStats, String>((ref, friendId) async {
  final repo = await ref.watch(statsRepositoryProvider.future);
  return repo.getFriendStats(friendId);
});