import 'package:flutter_app/data/models/chapter.dart';

/// Data model representing a biblical book and its collection of chapters.
class Book {
  final int bookId;
  final String bookName;
  final List<Chapter> chapters;

  Book({required this.bookId, required this.bookName, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    var chaptersList = json['chapters'] as List;
    List<Chapter> bookChapters = chaptersList.map((i) => Chapter.fromJson(i)).toList();

    return Book(
      bookId: json['book_id'] as int,
      bookName: json['book_name'] as String,
      chapters: bookChapters,
    );
  }
}