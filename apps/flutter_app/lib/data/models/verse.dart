class Verse {
  final int verseNumber;
  final String text;

  Verse({required this.verseNumber, required this.text});

  // Factory constructor to create a Verse object from a JSON map
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verse_number'] as int,
      text: json['text'] as String,
    );
  }
}