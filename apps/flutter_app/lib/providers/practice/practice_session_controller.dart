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
  final bool isInfiniteMode;

  PracticeSessionState({
    required this.queue,
    this.completedCount = 0,
    this.isFinished = false,
    this.isInfiniteMode = false,
  });

  PracticeSessionState copyWith({
    List<PracticeTurn>? queue,
    int? completedCount,
    bool? isFinished,
    bool? isInfiniteMode,
  }) {
    return PracticeSessionState(
      queue: queue ?? this.queue,
      completedCount: completedCount ?? this.completedCount,
      isFinished: isFinished ?? this.isFinished,
      isInfiniteMode: isInfiniteMode ?? this.isInfiniteMode,
    );
  }
}

/// Orchestrates the practice session flow, handles game randomization, and processes results.
class PracticeSessionController extends Notifier<PracticeSessionState> {
  final _random = Random();
  GameType? _lastGame;

  @override
  PracticeSessionState build() {
    return PracticeSessionState(queue: []);
  }

  GameType _getRandomGame({bool isInfiniteSession = false}) {
    final availableGames = [
      GameType.flashcard, 
      GameType.wordChoice, 
      GameType.firstLetterTyping,
      GameType.verseBuilder
    ];
    if(!isInfiniteSession){
      availableGames.add(GameType.referenceMatch);
    }

    if (_lastGame != null && availableGames.length > 1) {
      availableGames.remove(_lastGame);
    }

    final selectedGame = availableGames[_random.nextInt(availableGames.length)];
    _lastGame = selectedGame;

    return selectedGame;
  }

  void startSession(List<SavedVerse> verses, {GameType? forcedGameType}) {
    final initialQueue = verses.map((v) {
      return PracticeTurn(
        verse: v, 
        gameType: forcedGameType ?? _getRandomGame(),
      );
    }).toList()..shuffle();

    state = PracticeSessionState(queue: initialQueue, isInfiniteMode: false);
  }

  void startInfiniteSession(SavedVerse verse) {
    state = PracticeSessionState(
      queue: [PracticeTurn(verse: verse, gameType: _getRandomGame(isInfiniteSession: true))],
      isInfiniteMode: true,
    );
  }

  Future<void> submitFeedback(PracticeFeedback feedback) async {
    final currentTurn = state.queue.first;
    
    ref.read(practiceRepositoryProvider).savePracticeResult(feedback).catchError((_) {});

    final newQueue = List<PracticeTurn>.from(state.queue);
    newQueue.removeAt(0);

    if (state.isInfiniteMode) {
      newQueue.add(PracticeTurn(verse: currentTurn.verse, gameType: _getRandomGame(isInfiniteSession: true)));
      state = state.copyWith(
        queue: newQueue,
        completedCount: state.completedCount + 1,
      );
      return;
    }

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