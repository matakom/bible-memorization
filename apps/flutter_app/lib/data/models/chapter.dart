import 'package:flutter_app/data/models/verse.dart';

class Chapter {
  final int chapterNumber;
  final List<Verse> verses;

  Chapter({required this.chapterNumber, required this.verses});

  // Factory constructor to create a Chapter object from a JSON map
  factory Chapter.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<Verse> chapterVerses = versesList.map((i) => Verse.fromJson(i)).toList();

    return Chapter(
      chapterNumber: json['chapter_number'] as int,
      verses: chapterVerses,
    );
  }
}