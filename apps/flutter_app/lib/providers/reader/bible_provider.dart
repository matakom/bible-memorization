import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/book.dart';
import 'package:flutter_app/data/models/chapter.dart';
import 'package:flutter_app/data/repositories/bible_repository.dart';

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return BibleRepository(assetPath: 'assets/bible/b21.json');
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