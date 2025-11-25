class SavedVerse {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String translation;
  final DateTime? nextReviewDate;
  final DateTime? lastReviewDate;
  final int difficulty;

  SavedVerse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.translation,
    this.nextReviewDate,
    this.lastReviewDate,
    required this.difficulty,
  });

  factory SavedVerse.fromJson(Map<String, dynamic> json) {
    return SavedVerse(
      id: json['id'] as String,
      book: json['book'] as int,
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      translation: json['translation'] as String,
      nextReviewDate: json['nextReviewDate'] != null
          ? DateTime.parse(json['nextReviewDate'] as String)
          : null,
      lastReviewDate: json['lastReviewDate'] != null
          ? DateTime.parse(json['lastReviewDate'] as String)
          : null,
      difficulty: json['difficulty'] as int? ?? 1, 
    );
  }
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