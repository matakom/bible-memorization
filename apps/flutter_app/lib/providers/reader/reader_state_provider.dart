import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the current location (book, chapter, translation) in the Bible reader.
class ReaderState {
  final int bookId;
  final int chapterNum;
  final String translation;

  const ReaderState({required this.bookId, required this.chapterNum, required this.translation});

  ReaderState copyWith({int? bookId, int? chapterNum, String? translation}) {
    return ReaderState(
      bookId: bookId ?? this.bookId,
      chapterNum: chapterNum ?? this.chapterNum,
      translation: translation ?? this.translation,
    );
  }
}

/// Handles navigation logic and translation selection for the reader interface.
class ReaderNotifier extends Notifier<ReaderState> {
  @override
  ReaderState build() {
    return const ReaderState(bookId: 1, chapterNum: 1, translation: 'B21');
  }

  void selectBook(int newBookId) {
    state = state.copyWith(bookId: newBookId, chapterNum: 1);
  }

  void selectChapter(int newChapterNum) {
    state = state.copyWith(chapterNum: newChapterNum);
  }

  void selectTranslation(String translation) {
    state = state.copyWith(translation: translation);
  }
}

final readerProvider = NotifierProvider<ReaderNotifier, ReaderState>(ReaderNotifier.new);