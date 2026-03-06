/// Basic data model for a single verse's number and text.
class Verse {
  final int verseNumber;
  final String text;

  Verse({required this.verseNumber, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verse_number'] as int,
      text: json['text'] as String,
    );
  }
}