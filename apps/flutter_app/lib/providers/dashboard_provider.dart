import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import '../data/models/dashboard_stats.dart';
import './core/repository_providers.dart';

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) async* {
  // 1. Get the Database & Repository
  final db = ref.watch(databaseProvider);
  final statsRepo = ref.read(statsRepositoryProvider);

  // 2. Define the Triggers
  // We want to recalculate stats if ANY of these tables change.
  // (We added these watch methods to the DAOs in the previous step)
  final historyStream = db.exercisesDao.watchRecentHistory();
  final versesStream = db.savedVersesDao.watchAllSavedVerses();

  // 3. Initial Fetch
  // Show data immediately before waiting for the first change event
  yield await statsRepo.getDashboardStats();

  // 4. Watch for Changes
  // StreamGroup.merge combines both streams. If either emits, the loop triggers.
  await for (final _ in StreamGroup.merge([historyStream, versesStream])) {
    // Re-calculate the heavy math in the Repository
    final newStats = await statsRepo.getDashboardStats();
    yield newStats;
  }
});