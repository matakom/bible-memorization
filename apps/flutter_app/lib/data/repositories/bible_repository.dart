import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/models/book.dart';
import 'package:flutter_app/data/models/chapter.dart';

class BibleRepository {
  final String assetPath;
  
  // In-memory cache to avoid re-parsing JSON every time
  List<Book>? _cachedBooks;

  BibleRepository({required this.assetPath});

  /// Loads and parses the Bible data. 
  Future<List<Book>> getAllBooks() async {
    if (_cachedBooks != null) return _cachedBooks!;

    try {
      final String response = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      return _cachedBooks!;
    } catch (e) {
      throw Exception('Failed to load Bible data: $e');
    }
  }

  /// Fetches a specific chapter.
  Future<Chapter> getChapter(int bookId, int chapterNumber) async {
    final books = await getAllBooks();
    
    final book = books.firstWhere(
      (b) => b.bookId == bookId,
      orElse: () => throw Exception('Book ID $bookId not found'),
    );

    return book.chapters.firstWhere(
      (c) => c.chapterNumber == chapterNumber,
      orElse: () => throw Exception('Chapter $chapterNumber not found in ${book.bookName}'),
    );
  }
}