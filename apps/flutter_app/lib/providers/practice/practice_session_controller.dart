import 'dart:math';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/repositories/practice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. NEW: A wrapper to pair a verse with a specific game type
class PracticeTurn {
  final SavedVerse verse;
  final GameType gameType;

  PracticeTurn({required this.verse, required this.gameType});
}

class PracticeSessionState {
  final List<PracticeTurn> queue;
  final int completedCount;
  final bool isFinished;

  PracticeSessionState({
    required this.queue,
    this.completedCount = 0,
    this.isFinished = false,
  });

  PracticeSessionState copyWith({
    List<PracticeTurn>? queue,
    int? completedCount,
    bool? isFinished,
  }) {
    return PracticeSessionState(
      queue: queue ?? this.queue,
      completedCount: completedCount ?? this.completedCount,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class PracticeSessionController extends Notifier<PracticeSessionState> {
  final _random = Random();

  @override
  PracticeSessionState build() {
    return PracticeSessionState(queue: []);
  }

  // 2. Randomly assign a game type
  GameType _getRandomGame() {
    // We will add the other games here as we build them!
    final availableGames = [
      GameType.flashcard, 
      GameType.wordChoice, 
      GameType.referenceMatch,
      GameType.firstLetterTyping,
      GameType.verseBuilder
      ];
    return availableGames[_random.nextInt(availableGames.length)];
  }

  void startSession(List<SavedVerse> verses) {
    // Map each verse to a random game turn
    final initialQueue = verses.map((v) {
      return PracticeTurn(verse: v, gameType: _getRandomGame());
    }).toList();

    state = PracticeSessionState(queue: initialQueue);
  }

  Future<void> submitFeedback(PracticeFeedback feedback) async {
    final currentTurn = state.queue.first;
    
    // Save to database asynchronously
    ref.read(practiceRepositoryProvider).savePracticeResult(feedback).catchError((e) {
      // Log error silently
    });

    final newQueue = List<PracticeTurn>.from(state.queue);
    newQueue.removeAt(0);

    int newCompletedCount = state.completedCount;

    if (feedback.grade < 3) {
      // Fail: Put it at the back of the queue. 
      // Let's force it to be a Flashcard for the retry so they can study it properly!
      newQueue.add(PracticeTurn(verse: currentTurn.verse, gameType: GameType.flashcard));
    } else {
      newCompletedCount++;
    }

    state = state.copyWith(
      queue: newQueue,
      completedCount: newCompletedCount,
      isFinished: newQueue.isEmpty,
    );
  }
}

final practiceSessionProvider = NotifierProvider<PracticeSessionController, PracticeSessionState>(() {
  return PracticeSessionController();
});