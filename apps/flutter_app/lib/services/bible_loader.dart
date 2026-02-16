import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../data/local/app_database.dart';
import '../config/bible_translations.dart';

class BibleLoader {
  final AppDatabase _db;

  BibleLoader(this._db);

  /// Checks DB for missing translations and loads them.
  Future<void> initialize() async {
    // 1. Get list of translations currently in the DB
    final existingCodes = await _getExistingTranslationCodes();
    
    // 2. Compare with your Config to find what is missing
    final missingTranslations = AvailableBibleTranslations.where(
      (config) => !existingCodes.contains(config.abbreviation)
    ).toList();

    if (missingTranslations.isEmpty) {
      print("Bible Bootstrapper: All translations are up to date.");
      return;
    }

    print("Bible Bootstrapper: Found ${missingTranslations.length} missing translations. Loading...");
    await _seedSpecificTranslations(missingTranslations);
  }

  /// Queries the DB for distinct translation codes (e.g., {'B21', 'EK'})
  Future<Set<String>> _getExistingTranslationCodes() async {
    // Use selectOnly with distinct: true to get unique translation codes efficiently
    final query = _db.selectOnly(_db.bibleBooks, distinct: true)
      ..addColumns([_db.bibleBooks.translation]);
    
    final results = await query.get();
    
    return results
        .map((row) => row.read(_db.bibleBooks.translation))
        .whereType<String>() // Filter out nulls if any
        .toSet();
  }

  Future<void> _seedSpecificTranslations(List<BibleTranslation> translationsToLoad) async {
    final verseCompanions = <LocalBibleVersesCompanion>[];
    final bookCompanions = <BibleBooksCompanion>[];

    for (final translation in translationsToLoad) {
      try {
        final jsonString = await rootBundle.loadString(translation.assetPath);
        final List<dynamic> jsonData = json.decode(jsonString);

        for (final bookData in jsonData) {
          final bookId = bookData['book_id'] as int;
          final bookName = bookData['book_name'] as String;
          final chapters = bookData['chapters'] as List<dynamic>;

          bookCompanions.add(BibleBooksCompanion(
            id: Value(bookId),
            name: Value(bookName),
            translation: Value(translation.abbreviation),
          ));

          for (final chapterData in chapters) {
            final chapterNum = chapterData['chapter_number'] as int;
            final verses = chapterData['verses'] as List<dynamic>;

            for (final verseData in verses) {
              final verseNum = verseData['verse_number'] as int;
              final text = verseData['text'] as String;

              verseCompanions.add(LocalBibleVersesCompanion(
                book: Value(bookId),
                chapter: Value(chapterNum),
                verse: Value(verseNum),
                textContent: Value(text),
                translation: Value(translation.abbreviation),
                wordCount: Value(text.split(' ').length),
              ));
            }
          }
        }
        print("Parsed ${translation.name}...");
      } catch (e) {
        print("Error parsing ${translation.name}: $e");
      }
    }

    if (bookCompanions.isNotEmpty) {
      print("Batch inserting ${verseCompanions.length} verses...");
      await _db.batch((batch) {
        batch.insertAll(_db.bibleBooks, bookCompanions, mode: InsertMode.insertOrReplace);
        batch.insertAll(_db.localBibleVerses, verseCompanions, mode: InsertMode.insertOrReplace);
      });
      print("Seed complete.");
    }
  }
}