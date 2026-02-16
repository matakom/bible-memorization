import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/saved_verses.dart';
import '../tables/local_bible_verses.dart';
import '../tables/exercises.dart';

part 'saved_verses_dao.g.dart';

@DriftAccessor(tables: [SavedVerses, LocalBibleVerses, Exercises])
class SavedVersesDao extends DatabaseAccessor<AppDatabase> with _$SavedVersesDaoMixin {
  SavedVersesDao(super.db);

  Future<List<SavedVerse>> getAllVerseStats() {
    return select(savedVerses).get();
  }
  
  Stream<List<SavedVerse>> watchAllSavedVerses() {
    // This returns the raw rows (SavedVerse), not the domain model.
    // This is perfect for a "trigger" stream.
    return select(savedVerses).watch();
  }

  /// 1. Get Due Verses (JOINED with Text)
  Future<List<TypedResult>> getDueVersesWithText({int limit = 20}) {
    final now = DateTime.now();
    
    final query = select(savedVerses).join([
      innerJoin(
        localBibleVerses,
        localBibleVerses.book.equalsExp(savedVerses.book) &
        localBibleVerses.chapter.equalsExp(savedVerses.chapter) &
        localBibleVerses.verse.equalsExp(savedVerses.verse) &
        localBibleVerses.translation.equalsExp(savedVerses.translation)
      )
    ]);

    query.where(savedVerses.nextReviewDate.isSmallerOrEqualValue(now));
    query.orderBy([OrderingTerm(expression: savedVerses.nextReviewDate)]);
    query.limit(limit);

    return query.get();
  }

  Future<List<int>> getSavedVerseNumbersForChapter(int book, int chapter, String translationId) {
  final query = select(savedVerses)
    ..where((t) => 
      t.book.equals(book) & 
      t.chapter.equals(chapter) & 
      t.translation.equals(translationId) // Ensure we check the right translation
    );
  
  // We only need the verse numbers, not the whole object
  return query.map((row) => row.verse).get();
}

  /// 2. Get All Saved Verses (JOINED with Text) - For Lists
  Future<List<TypedResult>> getAllVersesWithText() {
    final query = select(savedVerses).join([
      innerJoin(
        localBibleVerses,
        localBibleVerses.book.equalsExp(savedVerses.book) &
        localBibleVerses.chapter.equalsExp(savedVerses.chapter) &
        localBibleVerses.verse.equalsExp(savedVerses.verse) &
        localBibleVerses.translation.equalsExp(savedVerses.translation)
      )
    ]);
    
    query.orderBy([OrderingTerm(expression: savedVerses.book), OrderingTerm(expression: savedVerses.chapter)]);
    
    return query.get();
  }

  /// 3. Get Single Verse by ID (JOINED with Text)
  Future<TypedResult?> getVerseWithTextById(String id) {
    final query = select(savedVerses).join([
      innerJoin(
        localBibleVerses,
        localBibleVerses.book.equalsExp(savedVerses.book) &
        localBibleVerses.chapter.equalsExp(savedVerses.chapter) &
        localBibleVerses.verse.equalsExp(savedVerses.verse) &
        localBibleVerses.translation.equalsExp(savedVerses.translation)
      )
    ]);

    query.where(savedVerses.id.equals(id));
    
    return query.getSingleOrNull();
  }

  /// 4. Insert
  Future<int> insertSavedVerse(SavedVersesCompanion entry) {
    return into(savedVerses).insert(entry);
  }

  /// 5. Update Stats
  Future<void> updateSavedVerse(SavedVersesCompanion entry) {
    return (update(savedVerses)
      ..where((t) => t.id.equals(entry.id.value))
    ).write(entry);
  }

  /// 6. HARD Delete
  Future<void> deleteVerse(String uuid) {
    return transaction(() async {
      // Hard delete related exercises first (foreign key hygiene)
      await (delete(exercises)..where((t) => t.savedVerseId.equals(uuid))).go();
      
      // Hard delete the verse itself
      await (delete(savedVerses)..where((t) => t.id.equals(uuid))).go();
    });
  }
}