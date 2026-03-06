/// Model for a verse saved by the user, containing Spaced Repetition statistics.
class SavedVerse {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String translation;
  final String verseText;
  final double easeFactor;
  final DateTime nextReviewDate;
  final DateTime? lastReviewDate;
  final int repetitionCount;


  SavedVerse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.translation,
    required this.verseText,
    required this.easeFactor,
    required this.nextReviewDate,
    this.lastReviewDate,
    this.repetitionCount = 0,
  });
}

/// Payload used for transmitting new verse data to the backend.
class VerseCreationPayload {
  final int book;
  final int chapter;
  final int verse;
  final String translation;
  final String text;

  VerseCreationPayload({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.translation,
    required this.text
  });

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'translation': translation,
      'text': text
    };
  }
}