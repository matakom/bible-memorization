class SavedVerse {
  SavedVerse({
    required this.id,
    required this.userId,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.translation,
    this.nextReviewDate,
    this.lastReviewDate,
    this.difficulty, // DEFAULT 1
  });

  factory SavedVerse.fromJson(Map<String, Object?> json) {
    return SavedVerse(
      id: json['id']! as int,
      userId: json['user_id']! as int,
      book: json['book']! as String,
      chapter: json['chapter']! as int,
      verse: json['verse']! as int,
      translation: json['translation']! as String,
      nextReviewDate: json['next_review_date'] == null
          ? null
          : DateTime.parse(json['next_review_date']! as String),
      lastReviewDate: json['last_review_date'] == null
          ? null
          : DateTime.parse(json['last_review_date']! as String),
      difficulty: json['difficulty'] as int?,
    );
  }

  final int id;
  final int userId;
  final String book;
  final int chapter;
  final int verse;
  final String translation;
  final DateTime? nextReviewDate;
  final DateTime? lastReviewDate;
  final int? difficulty;
}