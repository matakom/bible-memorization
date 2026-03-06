import 'dart:math';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/repositories/practice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a single unit of work in a practice session.
class PracticeTurn {
  final SavedVerse verse;
  final GameType gameType;

  PracticeTurn({required this.verse, required this.gameType});
}

/// Holds the current state of an active practice session.
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

/// Orchestrates the practice session flow, handles game randomization, and processes results.
class PracticeSessionController extends Notifier<PracticeSessionState> {
  final _random = Random();

  @override
  PracticeSessionState build() {
    return PracticeSessionState(queue: []);
  }

  GameType _getRandomGame() {
    final availableGames = [
      GameType.flashcard, 
      GameType.wordChoice, 
      GameType.referenceMatch,
      GameType.firstLetterTyping,
      GameType.verseBuilder
    ];
    return availableGames[_random.nextInt(availableGames.length)];
  }

  void startSession(List<SavedVerse> verses, {GameType? forcedGameType}) {
    final initialQueue = verses.map((v) {
      return PracticeTurn(
        verse: v, 
        gameType: forcedGameType ?? _getRandomGame(),
      );
    }).toList()..shuffle();

    state = PracticeSessionState(queue: initialQueue);
  }

  Future<void> submitFeedback(PracticeFeedback feedback) async {
    final currentTurn = state.queue.first;
    
    ref.read(practiceRepositoryProvider).savePracticeResult(feedback).catchError((_) {});

    final newQueue = List<PracticeTurn>.from(state.queue);
    newQueue.removeAt(0);

    int newCompletedCount = state.completedCount;

    if (feedback.grade < 3) {
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