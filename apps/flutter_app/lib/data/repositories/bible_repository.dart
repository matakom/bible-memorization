import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../local/daos/bible_dao.dart';
import '../models/book.dart';
import '../models/verse.dart';

/// Repository for getting bible text
class BibleRepository {
  final BibleDao _dao;

  BibleRepository(this._dao);

  Future<Verse?> getVerse({
    required int book,
    required int chapter,
    required int verse,
    required String translation
  }) async {
    final row = await _dao.getVerse(book, chapter, verse, translation);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  Future<List<Verse>> getChapter(int book, int chapter, String translation) async {
    final rows = await _dao.getChapter(book, chapter, translation);
    return rows.map(_mapToDomain).toList();
  }

  Future<List<Book>> getBooks(String translation) async {
    // 1. Get raw rows from DAO
    final rows = await _dao.getBooks(translation);
    
    // 2. Map Drift class (BibleBook) to Domain class (Book)
    return rows.map((row) => Book(
      id: row.id,
      name: row.name,
    )).toList();
  }

  Verse _mapToDomain(LocalBibleVerse row) {
    return Verse(
      book: row.book,
      chapter: row.chapter,
      verse: row.verse,
      text: row.textContent,
      translation: row.translation,
      wordCount: row.wordCount,
    );
  }
}

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BibleRepository(db.bibleDao);
});