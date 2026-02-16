/// Represents the immutable content of a Bible verse.
class Verse {
  final int book; 
  final int chapter;
  final int verse;
  final String text;
  final String translation;
  final int wordCount;

  const Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.translation,
    required this.wordCount,
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      book: map['book'],
      chapter: map['chapter'],
      verse: map['verse'],
      text: map['textContent'], 
      translation: map['translation'] ?? 'default', 
      wordCount: map['wordCount'],
    );
  }
}