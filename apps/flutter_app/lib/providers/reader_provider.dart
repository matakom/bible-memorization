import 'package:flutter_app/providers/current_translation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/verse.dart'; // Your existing class
import '../data/local/app_database.dart' hide databaseProvider; // Fix ambiguous import
import './core/repository_providers.dart';

/// Wraps your domain Verse with UI state (Checkmark)
class ReaderVerseState {
  final Verse verse;
  final bool isSaved;

  ReaderVerseState(this.verse, this.isSaved);
}

// 1. Get Books (Unchanged)
final bibleBooksProvider = FutureProvider<List<BibleBook>>((ref) async {
  final db = ref.watch(databaseProvider);
  
  // Watch the selected translation ID (e.g. 'b21', 'kralicka')
  // This causes the provider to re-execute immediately when the user changes selection.
  final currentTranslation = ref.watch(currentTranslationProvider);
  
  return await db.bibleDao.getBooks(currentTranslation);
});

// 2. Get Chapter (Dynamic)
final bibleChapterProvider = FutureProvider.family<List<ReaderVerseState>, ({int bookId, int chapter})>((ref, args) async {
  final db = ref.watch(databaseProvider);
  
  // 1. Get current translation
  final currentTranslation = ref.watch(currentTranslationProvider);

  // 2. Run both database queries in PARALLEL for speed
  final results = await Future.wait([
    // A. Fetch the text
    db.bibleDao.getVersesForChapter(
      args.bookId, 
      args.chapter, 
      currentTranslation
    ),
    // B. Fetch ONLY the saved status for this specific chapter (Optimized)
    db.savedVersesDao.getSavedVerseNumbersForChapter(
      args.bookId, 
      args.chapter, 
      currentTranslation
    ),
  ]);

  final rawRows = results[0] as List<LocalBibleVerse>;
  final savedVerseNumbers = results[1] as List<int>;
  final savedSet = savedVerseNumbers.toSet(); // Fast lookup

  // 3. Map to UI
  return rawRows.map((row) {
    final verseDomain = Verse(
      book: row.book,
      chapter: row.chapter,
      verse: row.verse,
      text: row.textContent,
      translation: row.translation,
      wordCount: row.wordCount,
    );

    return ReaderVerseState(verseDomain, savedSet.contains(row.verse));
  }).toList();
});

// 3. Controller
final readerControllerProvider = Provider((ref) => ReaderController(ref));

class ReaderController {
  final Ref _ref;
  ReaderController(this._ref);

  Future<void> toggleVerse(ReaderVerseState item) async {
    final repo = _ref.read(savedVersesRepositoryProvider);
    
    if (!item.isSaved) {
      // Pass the Verse object directly to the repository
      await repo.addNewVerse(item.verse);
      
      // Refresh UI
      _ref.invalidate(bibleChapterProvider);
    }
  }
}