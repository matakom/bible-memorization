import 'package:flutter/material.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/l10n/l10n_extension.dart'; 
import 'package:flutter_app/presentation/widgets/games/first_letter_typing_game_widget.dart';
import 'package:flutter_app/presentation/widgets/games/reference_match_game_widget.dart';
import 'package:flutter_app/presentation/widgets/games/verse_builder_game_widget.dart';
import 'package:flutter_app/presentation/widgets/games/word_choice_game_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/presentation/widgets/games/flashcard_game_widget.dart';

/// The active gameplay container that renders specific exercise widgets and handles session completion.
class PracticeShellScreen extends ConsumerWidget {
  const PracticeShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(practiceSessionProvider);

    if (sessionState.queue.isEmpty && !sessionState.isFinished) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (sessionState.isFinished) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                context.l10n.practiceShell_sessionComplete,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(context.l10n.practiceShell_versesMastered(sessionState.completedCount)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: Text(context.l10n.practiceShell_finish),
              )
            ],
          ),
        ),
      );
    }

    final currentTurn = sessionState.queue.first;
    final currentVerse = currentTurn.verse;
    
    Widget gameWidget;
    switch (currentTurn.gameType) {
      case GameType.wordChoice:
        gameWidget = WordChoiceGameWidget(key: ValueKey(currentVerse.id), verse: currentVerse);
        break;
      case GameType.firstLetterTyping:
        gameWidget = FirstLetterTypingGameWidget(key: ValueKey(currentVerse.id), verse: currentVerse);
        break;
      case GameType.referenceMatch:
        gameWidget = ReferenceMatchGameWidget(key: ValueKey(currentVerse.id), verse: currentVerse);
        break;
      case GameType.verseBuilder:
        gameWidget = VerseBuilderGameWidget(key: ValueKey(currentVerse.id), verse: currentVerse);
        break;
      case GameType.flashcard:
        gameWidget = FlashcardGameWidget(key: ValueKey(currentVerse.id), verse: currentVerse);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.practiceShell_remaining(sessionState.queue.length)),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: gameWidget,
    );
  }
}