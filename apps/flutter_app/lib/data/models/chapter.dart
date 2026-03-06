import 'package:flutter_app/data/models/verse.dart';

/// Data model representing a biblical chapter containing a list of verses.
class Chapter {
  final int chapterNumber;
  final List<Verse> verses;

  Chapter({required this.chapterNumber, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<Verse> chapterVerses = versesList.map((i) => Verse.fromJson(i)).toList();

    return Chapter(
      chapterNumber: json['chapter_number'] as int,
      verses: chapterVerses,
    );
  }
}