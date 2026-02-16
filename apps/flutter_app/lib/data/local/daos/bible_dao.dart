import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/bible_books.dart';
import '../tables/local_bible_verses.dart';

part 'bible_dao.g.dart';

@DriftAccessor(tables: [LocalBibleVerses, BibleBooks])
class BibleDao extends DatabaseAccessor<AppDatabase> with _$BibleDaoMixin {
  BibleDao(super.db);

  /// Fetches single verse
  Future<LocalBibleVerse?> getVerse(int book, int chapter, int verse, String translation) {
    return (select(localBibleVerses)
      ..where((t) => t.book.equals(book) & 
                     t.chapter.equals(chapter) & 
                     t.verse.equals(verse) &
                     t.translation.equals(translation))
      ).getSingleOrNull();
  }

  /// Fetches chapter
  Future<List<LocalBibleVerse>> getChapter(int book, int chapter, String translation) {
    return (select(localBibleVerses)
      ..where((t) => t.book.equals(book) & t.chapter.equals(chapter) & t.translation.equals(translation))
      ..orderBy([(t) => OrderingTerm(expression: t.verse)]))
      .get();
  }

  Future<List<LocalBibleVerse>> getVersesForChapter(int book, int chapter, String translation) {
  return (select(localBibleVerses)
    ..where((t) => t.book.equals(book) & t.chapter.equals(chapter) & t.translation.equals(translation))
    ..orderBy([(t) => OrderingTerm(expression: t.verse)]))
    .get();
  }

  Future<List<int>> getAllBookIds() async {
    final query = selectOnly(localBibleVerses, distinct: true)
      ..addColumns([localBibleVerses.book]);
    
    final results = await query.get();
    return results.map((row) => row.read(localBibleVerses.book)!).toList();
  }

  Future<List<BibleBook>> getBooks(String translationId) {
    return (select(bibleBooks)
      ..where((t) => t.translation.equals(translationId)))
      .get();
  }

  /// Bulk Insert (For JSON Importer)
  Future<void> insertVersesBatch(List<LocalBibleVersesCompanion> rows) async {
    await batch((batch) {
      batch.insertAll(localBibleVerses, rows);
    });
  }

  Future<void> insertBooksBatch(List<BibleBooksCompanion> books) {
    return batch((batch) {
      batch.insertAll(bibleBooks, books, mode: InsertMode.insertOrReplace);
    });
  }
}