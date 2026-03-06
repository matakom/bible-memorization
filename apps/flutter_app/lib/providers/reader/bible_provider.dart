import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/models/book.dart';
import 'package:flutter_app/data/models/chapter.dart';
import 'package:flutter_app/data/repositories/bible_repository.dart';
import 'package:flutter_app/config/bible_translations.dart'; 

/// Manages the persistence and state of the selected Bible translation.
class BibleTranslationNotifier extends AsyncNotifier<BibleTranslation> {
  static const _kPrefKey = 'selected_bible_version_id';

  @override
  Future<BibleTranslation> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_kPrefKey);

    return availableBibleTranslations.firstWhere(
      (v) => v.id == savedId,
      orElse: () => availableBibleTranslations.first,
    );
  }

  Future<void> setVersion(BibleTranslation version) async {
    state = AsyncData(version);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, version.id);
  }
}

final currentBibleTranslationProvider = 
    AsyncNotifierProvider<BibleTranslationNotifier, BibleTranslation>(BibleTranslationNotifier.new);

/// Provides a BibleRepository instance based on the currently selected translation.
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final versionAsync = ref.watch(currentBibleTranslationProvider);
  final currentVersion = versionAsync.maybeWhen(
    data: (data) => data,
    orElse: () => availableBibleTranslations.first,
  );
  return BibleRepository(assetPath: currentVersion.assetPath);
});

final bibleBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(bibleRepositoryProvider).getAllBooks();
});

class ChapterRef {
  final int bookId;
  final int chapterNum;
  const ChapterRef(this.bookId, this.chapterNum);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterRef && bookId == other.bookId && chapterNum == other.chapterNum;

  @override
  int get hashCode => bookId.hashCode ^ chapterNum.hashCode;
}

final chapterContentProvider = FutureProvider.family<Chapter, ChapterRef>((ref, chapterRef) async {
  return ref.watch(bibleRepositoryProvider).getChapter(chapterRef.bookId, chapterRef.chapterNum);
});

final bookNameProvider = FutureProvider.family<String, int>((ref, bookId) async {
  return ref.watch(bibleRepositoryProvider).getBookName(bookId);
});