import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderState {
  final int bookId;
  final int chapterNum;

  const ReaderState({required this.bookId, required this.chapterNum});

  ReaderState copyWith({int? bookId, int? chapterNum}) {
    return ReaderState(
      bookId: bookId ?? this.bookId,
      chapterNum: chapterNum ?? this.chapterNum,
    );
  }
}

class ReaderNotifier extends Notifier<ReaderState> {
  @override
  ReaderState build() {
    return const ReaderState(bookId: 1, chapterNum: 1);
  }

  void selectBook(int newBookId) {
    state = ReaderState(bookId: newBookId, chapterNum: 1);
  }

  void selectChapter(int newChapterNum) {
    state = state.copyWith(chapterNum: newChapterNum);
  }
}

final readerProvider = NotifierProvider<ReaderNotifier, ReaderState>(() {
  return ReaderNotifier();
});