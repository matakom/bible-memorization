import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../local/daos/exercises_dao.dart';
import '../local/daos/saved_verses_dao.dart';
import '../models/dashboard_stats.dart';

class StatsRepository {
  final ExercisesDao _exercisesDao;
  final SavedVersesDao _versesDao;

  StatsRepository(this._exercisesDao, this._versesDao);

  Future<DashboardStats> getDashboardStats() async {
    final historyFuture = _exercisesDao.getRecentHistory();
    final versesFuture = _versesDao.getAllVerseStats();

    final results = await Future.wait([historyFuture, versesFuture]);
    final history = results[0] as List<Exercise>;
    final allVerses = results[1] as List<SavedVerse>;

    final streak = _calculateStreak(history);
    final totalVerses = allVerses.length;
    
    // "Mastered" Logic:
    // A verse is mastered if the interval is > 21 days (3 weeks).
    final masteredVerses = allVerses.where((v) => v.sm2IntervalDays > 21).length;
    
    // Add count(*) to dao
    final totalReviews = history.length; 

    return DashboardStats(
      currentStreak: streak,
      totalVerses: totalVerses,
      masteredVerses: masteredVerses,
      totalReviews: totalReviews,
      // TODO: DO NOT HARDCODE THIS
      globalRetention: 0.0
    );
  }

  /// Calculates consecutive days of practice.
  int _calculateStreak(List<Exercise> history) {
    if (history.isEmpty) return 0;

    // Normalize dates to YYYY-MM-DD (ignoring time)
    final practiceDates = history.map((e) {
      final d = e.performedAt;
      return DateTime(d.year, d.month, d.day);
    }).toSet();

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    // If no practice today AND no practice yesterday, streak is broken.
    if (!practiceDates.contains(todayDate) && !practiceDates.contains(yesterdayDate)) {
      return 0;
    }

    int streak = 0;
    // Start checking from Today (or Yesterday if haven't practiced yet today)
    DateTime checkDate = practiceDates.contains(todayDate) ? todayDate : yesterdayDate;

    // Count backwards
    while (practiceDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StatsRepository(db.exercisesDao, db.savedVersesDao);
});