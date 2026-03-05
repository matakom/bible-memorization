import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/data/models/practice_feedback.dart'; 
import 'package:flutter_app/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/utils/srs_algorithm.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_app/services/sync_service.dart';

// Import these so we can trigger a UI refresh!
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';

class PracticeRepository {
  final db.AppDatabase _db;
  final Ref _ref;

  PracticeRepository(this._db, this._ref);

  Future<void> savePracticeResult(PracticeFeedback feedback) async {
    final now = DateTime.now();
    final exerciseId = const Uuid().v4();

    await _db.transaction(() async {
      // 1. Save the Exercise Log (Drift handles the GameType enum perfectly!)
      await _db.into(_db.exercises).insert(
        db.ExercisesCompanion.insert(
          id: exerciseId,
          verseId: feedback.verseId,
          grade: feedback.grade,
          exerciseType: feedback.gameType, 
          durationSeconds: feedback.durationSeconds,
          performedAt: Value(now),
          updatedAt: Value(now),
          needsSync: const Value(true),
        ),
      );

      // 2. Fetch the verse we just practiced
      final verseRow = await (_db.select(_db.savedVerses)
            ..where((t) => t.id.equals(feedback.verseId)))
          .getSingleOrNull();

      if (verseRow != null) {
        // 3. Process SM-2 Interval logic
        final srsResult = SRSAlgorithm.processReview(
          currentGrade: feedback.grade,
          currentEaseFactor: verseRow.easeFactor,
          currentRepetitionCount: verseRow.repetitionCount,
          lastReviewDate: verseRow.lastReviewDate ?? now,
          currentNextReviewDate: verseRow.nextReviewDate,
        );

        // 5. Save everything back to SQLite
        await (_db.update(_db.savedVerses)..where((t) => t.id.equals(feedback.verseId)))
            .write(
          db.SavedVersesCompanion(
            easeFactor: Value(srsResult.easeFactor),
            repetitionCount: Value(srsResult.repetitionCount),
            nextReviewDate: Value(srsResult.nextReviewDate),
            lastReviewDate: Value(now),
            updatedAt: Value(now),
            needsSync: const Value(true),
          ),
        );
      }
    });

    // 6. Push daily local notification reminder to tomorrow
    await NotificationService.scheduleDailyReminder(true);

    // 7. FIX 2: Invalidate the providers so the Dashboard immediately updates!
    _ref.invalidate(savedVersesControllerProvider);
    _ref.invalidate(myStatsProvider);

    try {
      final syncService = await _ref.read(syncServiceProvider.future);
      syncService.runSync();
    } catch (_) {}
  }
}

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  final database = ref.watch(db.databaseProvider);
  return PracticeRepository(database, ref);
});