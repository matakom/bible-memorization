import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/utils/srs_algorithm.dart';
import 'package:uuid/uuid.dart';
import '../../services/sync_service.dart';

class PracticeResult {
  final String verseId;
  final int grade; // 0-5
  final String exerciseType;
  final int durationSeconds;

  PracticeResult({
    required this.verseId,
    required this.grade,
    required this.exerciseType,
    required this.durationSeconds,
  });
}

class PracticeRepository {
  final db.AppDatabase _db;
  final Ref _ref;

  PracticeRepository(this._db, this._ref);

  Future<void> savePracticeResult(PracticeResult result) async {
    final now = DateTime.now();
    final exerciseId = const Uuid().v4();

    await _db.transaction(() async {
      await _db.into(_db.exercises).insert(
        db.ExercisesCompanion.insert(
          id: exerciseId,
          verseId: result.verseId,
          grade: result.grade,
          exerciseType: result.exerciseType,
          durationSeconds: result.durationSeconds,
          performedAt: Value(now),
          updatedAt: Value(now),
          needsSync: const Value(true),
        ),
      );

      final verseRow = await (_db.select(_db.savedVerses)
            ..where((t) => t.id.equals(result.verseId)))
          .getSingleOrNull();

      if (verseRow != null) {
        final srsResult = SRSAlgorithm.processReview(
          currentGrade: result.grade,
          currentEaseFactor: verseRow.easeFactor,
          currentRepetitionCount: verseRow.repetitionCount,
          lastReviewDate: verseRow.lastReviewDate ?? now,
          currentNextReviewDate: verseRow.nextReviewDate,
        );

        await (_db.update(_db.savedVerses)..where((t) => t.id.equals(result.verseId)))
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

    try {
      final syncService = await _ref.read(syncServiceProvider.future);
      syncService.runSync();
    } catch (_) {
    }
  }
}

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  final database = ref.watch(db.databaseProvider);
  return PracticeRepository(database, ref);
});