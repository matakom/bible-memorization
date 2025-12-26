import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart'; // For SQL expressions
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:flutter_app/data/models/user_stats.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;

class StatsRepository {
  final Dio _dio;
  final db.AppDatabase _db;
  final SharedPreferences _prefs;

  StatsRepository(this._dio, this._db, this._prefs);

  Future<UserStats> getMyStats() async {
    // Get Name from Local Cache
    String fullName = "Me";
    final cachedUser = _prefs.getString('cached_user_profile');
    if (cachedUser != null) {
      try {
        final user = AppUser.fromJson(json.decode(cachedUser));
        fullName = "${user.firstName} ${user.lastName}";
      } catch (_) {}
    }

    // Count Total Verses
    final versesCountExpr = _db.savedVerses.id.count();
    final totalVerses =
        await (_db.selectOnly(_db.savedVerses)
              ..where(_db.savedVerses.deletedAt.isNull())
              ..addColumns([versesCountExpr]))
            .map((row) => row.read(versesCountExpr))
            .getSingle();

    // Count Mastered Verses (> 4 reps)
    final masteredExpr = _db.savedVerses.id.count();
    final masteredVerses =
        await (_db.selectOnly(_db.savedVerses)
              ..where(
                _db.savedVerses.deletedAt.isNull() &
                    _db.savedVerses.repetitionCount.isBiggerThanValue(4),
              )
              ..addColumns([masteredExpr]))
            .map((row) => row.read(masteredExpr))
            .getSingle();

    // Count Total Reviews
    final reviewsCountExpr = _db.exercises.id.count();
    final totalReviews =
        await (_db.selectOnly(_db.exercises)..addColumns([reviewsCountExpr]))
            .map((row) => row.read(reviewsCountExpr))
            .getSingle();

    // Calculate Accuracy
    final passedExpr = _db.exercises.id.count();
    final passedReviews =
        await (_db.selectOnly(_db.exercises)
              ..where(_db.exercises.grade.isBiggerOrEqualValue(3))
              ..addColumns([passedExpr]))
            .map((row) => row.read(passedExpr))
            .getSingle();

    double accuracy = 0.0;
    if (totalReviews != null && totalReviews > 0) {
      accuracy = ((passedReviews ?? 0) / totalReviews) * 100;
    }

    // Calculate Streak
    int currentStreak = 0;
    try {
      currentStreak = await _db.calculateLocalStreak();
    } catch (_) {}

    return UserStats(
      userId: 'me',
      fullName: fullName, 
      streak: currentStreak,
      totalVerses: totalVerses ?? 0,
      masteredVerses: masteredVerses ?? 0,
      totalReviews: totalReviews ?? 0,
      averageAccuracy: double.parse(accuracy.toStringAsFixed(1)),
    );
  }

  Stream<UserStats> watchMyStats() {
    return _db.customSelect(
      'SELECT 1',
      readsFrom: {_db.savedVerses, _db.exercises},
    ).watch().asyncMap((_) async {
      return await getMyStats();
    });
  }

  Future<UserStats> getFriendStats(String userId) async {
    try {
      final response = await _dio.get('/user/$userId/stats');
      return UserStats.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load friend stats');
    }
  }
}

// Updated Provider
final statsRepositoryProvider = FutureProvider((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);

  final database = ref.watch(db.databaseProvider);
  final prefs = await SharedPreferences.getInstance();

  return StatsRepository(dio, database, prefs);
});

final myStatsProvider = StreamProvider<UserStats>((ref) {
  final repo = ref.watch(statsRepositoryProvider).asData?.value;
  
  if (repo == null) return const Stream.empty();
  
  return repo.watchMyStats();
});

final friendStatsProvider = FutureProvider.family<UserStats, String>((
  ref,
  friendId,
) async {
  final repo = await ref.watch(statsRepositoryProvider.future);
  return repo.getFriendStats(friendId);
});