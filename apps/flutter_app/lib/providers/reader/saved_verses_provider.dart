import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/data/models/saved_verse.dart';

final currentSavedVersesProvider = StreamProvider.autoDispose<List<SavedVerse>>((ref) {
  final database = ref.watch(db.databaseProvider);
  
  final currentTranslation = ref.watch(currentBibleTranslationProvider).value;

  if (currentTranslation == null) return const Stream.empty();

  final query = database.select(database.savedVerses)
    ..where((t) => t.translation.equals(currentTranslation.abbreviation))
    ..where((t) => t.deletedAt.isNull())
    ..orderBy([
      (t) => OrderingTerm(expression: t.book, mode: OrderingMode.asc),
      (t) => OrderingTerm(expression: t.chapter, mode: OrderingMode.asc),
      (t) => OrderingTerm(expression: t.verse, mode: OrderingMode.asc),
    ]);

  return query.watch().map((rows) {
    return rows.map((row) {
      return SavedVerse(
        id: row.id,
        book: row.book,
        chapter: row.chapter,
        verse: row.verse,
        translation: row.translation,
        verseText: row.verseText,
        easeFactor: row.easeFactor,
        nextReviewDate: row.nextReviewDate,
        lastReviewDate: row.lastReviewDate,
      );
    }).toList();
  });
});