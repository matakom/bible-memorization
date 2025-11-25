import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';

class VerseRef {
  final int bookId;
  final int chapter;
  final int verse;

  VerseRef({
    required this.bookId,
    required this.chapter,
    required this.verse,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseRef &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          chapter == other.chapter &&
          verse == other.verse;

  @override
  int get hashCode => Object.hash(bookId, chapter, verse);
}

final verseTextProvider = FutureProvider.family<String, VerseRef>((ref, verseRef) async {
  final repository = ref.watch(bibleRepositoryProvider); 

  try {
    final verseObj = await repository.getVerse(
      verseRef.bookId, 
      verseRef.chapter, 
      verseRef.verse
    );
    
    return verseObj.text;
    
  } catch (e) {
    // This handles cases where the verse index might be out of bounds
    // or the book/chapter doesn't exist in the JSON.
    return "Text unavailable"; 
  }
});