import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages the set of selected verse numbers for bookmarking or saving.
class VerseSelectionNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void toggle(int verseNum) {
    if (state.contains(verseNum)) {
      state = {...state}..remove(verseNum);
    } else {
      state = {...state}..add(verseNum);
    }
  }

  void clear() => state = {};
}

final verseSelectionProvider = NotifierProvider<VerseSelectionNotifier, Set<int>>(() {
  return VerseSelectionNotifier();
});