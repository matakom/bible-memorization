import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/utils/srs_algorithm.dart';
import 'package:uuid/uuid.dart';
import '../../services/sync_service.dart';

class SavedVersesException implements Exception {
  final String message;
  SavedVersesException(this.message);

  @override
  String toString() => message;
}

class SavedVersesRepository {
  final db.AppDatabase _db;
  final Ref _ref;

  SavedVersesRepository(this._db, this._ref);
  /// Fetches all active saved verses from Local DB
  Future<List<SavedVerse>> getSavedVerses() async {
    try {
      // 1. Select from DB, filtering out soft-deleted items
      final query = _db.select(_db.savedVerses)
        ..where((t) => t.deletedAt.isNull())
        ..orderBy([
          // Order by next review date (Priority)
          (t) => OrderingTerm(expression: t.nextReviewDate, mode: OrderingMode.asc)
        ]);

      final rows = await query.get();

      return rows.map((row) {
        return SavedVerse(
          id: row.id,
          book: row.book,
          chapter: row.chapter,
          verse: row.verse,
          translation: row.translation,
          
          nextReviewDate: row.nextReviewDate,
          lastReviewDate: row.lastReviewDate,
          
          difficulty: row.easeFactor.round(), 
        );
      }).toList();
    } catch (e) {
      throw SavedVersesException('Failed to load local verses: $e');
    }
  }

  /// Saves new verses to Local DB (Offline First)
  Future<List<SavedVerse>> saveVerses(List<VerseCreationPayload> payloads) async {
    try {
      final List<SavedVerse> createdVerses = [];

      await _db.batch((batch) {
        for (final payload in payloads) {
          final uuid = const Uuid().v4();
          
          final text = payload.text;
          final complexity = SRSAlgorithm.calculateComplexity(text);
          final initialEf = SRSAlgorithm.getInitialEaseFactor(complexity);
          
          final initialNextReview = DateTime.now();

          batch.insert(
            _db.savedVerses,
            db.SavedVersesCompanion.insert(
              id: uuid,
              book: payload.book,
              chapter: payload.chapter,
              verse: payload.verse,
              translation: payload.translation,
              verseText: text,
              baseComplexity: Value(complexity),
              easeFactor: Value(initialEf),
              repetitionCount: const Value(0),
              nextReviewDate: initialNextReview,
              updatedAt: Value(DateTime.now()),
              needsSync: const Value(true),
            ),
          );

          createdVerses.add(SavedVerse(
            id: uuid,
            book: payload.book,
            chapter: payload.chapter,
            verse: payload.verse,
            translation: payload.translation,
            difficulty: initialEf.round(),
            nextReviewDate: initialNextReview,
          ));
        }
      });

      try {
      final syncService = await _ref.read(syncServiceProvider.future);
      syncService.runSync();
    } catch (_) {}
      return createdVerses;
    } catch (e) {
      throw SavedVersesException('Failed to save verses locally: $e');
    }

  }

  /// Soft Deletes a verse locally
  Future<void> deleteVerse(String id) async {
    try {
      await (_db.update(_db.savedVerses)..where((t) => t.id.equals(id)))
          .write(db.SavedVersesCompanion(
            deletedAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
            needsSync: const Value(true),
          ));
    } catch (e) {
      throw SavedVersesException('Failed to delete verse locally: $e');
    }
    try {
    final syncService = await _ref.read(syncServiceProvider.future);
    syncService.runSync();
  } catch (_) {}
  }
}

final savedVersesRepositoryProvider = Provider<SavedVersesRepository>((ref) {
  final database = ref.watch(db.databaseProvider); 
  return SavedVersesRepository(database, ref);
});