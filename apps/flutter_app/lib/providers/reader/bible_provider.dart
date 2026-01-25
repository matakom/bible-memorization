import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/models/book.dart';
import 'package:flutter_app/data/models/chapter.dart';
import 'package:flutter_app/data/repositories/bible_repository.dart';
import 'package:flutter_app/config/bible_translations.dart'; 

class BibleTranslationNotifier extends AsyncNotifier<BibleTranslation> {
  static const _kPrefKey = 'selected_bible_version_id';

  @override
  Future<BibleTranslation> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_kPrefKey);

    return AvailableBibleTranslations.firstWhere(
      (v) => v.id == savedId,
      orElse: () => AvailableBibleTranslations.first,
    );
  }

  Future<void> setVersion(BibleTranslation version) async {
    state = AsyncData(version); // Optimistic update
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, version.id);
  }
}

final currentBibleTranslationProvider = 
    AsyncNotifierProvider<BibleTranslationNotifier, BibleTranslation>(BibleTranslationNotifier.new);

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final versionAsync = ref.watch(currentBibleTranslationProvider);
  
  final currentVersion = versionAsync.maybeWhen(
    data: (data) => data,
    orElse: () => AvailableBibleTranslations.first,
  );
  return BibleRepository(assetPath: currentVersion.assetPath);
});

final bibleBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.watch(bibleRepositoryProvider);
  return repository.getAllBooks();
});

class ChapterRef {
  final int bookId;
  final int chapterNum;
  
  const ChapterRef(this.bookId, this.chapterNum);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterRef &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          chapterNum == other.chapterNum;

  @override
  int get hashCode => bookId.hashCode ^ chapterNum.hashCode;
}

final chapterContentProvider = FutureProvider.family<Chapter, ChapterRef>((ref, chapterRef) async {
  final repository = ref.watch(bibleRepositoryProvider);
  return repository.getChapter(chapterRef.bookId, chapterRef.chapterNum);
});

final bookNameProvider = FutureProvider.family<String, int>((ref, bookId) async {
  final repository = ref.watch(bibleRepositoryProvider); 
  return repository.getBookName(bookId);
});