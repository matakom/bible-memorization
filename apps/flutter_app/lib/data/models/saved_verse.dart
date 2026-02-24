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

  // --- NEW: History & HLR Stats ---
  final int repetitionCount;
  final int correctCount;
  final int incorrectCount;
  final double stability;
  final double difficulty;

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
    // Add defaults so you don't have to rewrite all your tests/mocks
    this.repetitionCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.stability = 0.0,
    this.difficulty = 0.0,
  });
}

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