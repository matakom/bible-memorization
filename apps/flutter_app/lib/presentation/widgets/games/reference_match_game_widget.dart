import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

/// Internal data class representing a multiple-choice reference option.
class _RefOption {
  final int book;
  final int chapter;
  final int verse;
  final bool isCorrect;

  _RefOption({required this.book, required this.chapter, required this.verse, required this.isCorrect});

  String get uniqueKey => '$book-$chapter-$verse';
}

/// A game widget where users match the displayed verse text to one of several book references.
class ReferenceMatchGameWidget extends ConsumerStatefulWidget {
  final SavedVerse verse;

  const ReferenceMatchGameWidget({super.key, required this.verse});

  @override
  ConsumerState<ReferenceMatchGameWidget> createState() => _ReferenceMatchGameWidgetState();
}

class _ReferenceMatchGameWidgetState extends ConsumerState<ReferenceMatchGameWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  late List<_RefOption> _options;

  @override
  void initState() {
    super.initState();
    _setupGame();
    _stopwatch.start();
  }

  void _setupGame() {
    final allVerses = ref.read(savedVersesControllerProvider).value ?? [];
    final Set<String> usedKeys = {};
    _options = [];

    final correctOpt = _RefOption(
      book: widget.verse.book,
      chapter: widget.verse.chapter,
      verse: widget.verse.verse,
      isCorrect: true,
    );
    _options.add(correctOpt);
    usedKeys.add(correctOpt.uniqueKey);

    final otherVerses = allVerses.where((v) => v.id != widget.verse.id).toList();
    otherVerses.shuffle();

    for (final v in otherVerses) {
      if (_options.length >= 4) break;
      final opt = _RefOption(book: v.book, chapter: v.chapter, verse: v.verse, isCorrect: false);
      if (!usedKeys.contains(opt.uniqueKey)) {
        _options.add(opt);
        usedKeys.add(opt.uniqueKey);
      }
    }

    final random = Random();
    while (_options.length < 4) {
      int fakeBook = widget.verse.book;
      int fakeChapter = widget.verse.chapter;
      int fakeVerse = widget.verse.verse;

      final trickType = random.nextInt(3);
      if (trickType == 0) {
        fakeChapter = max(1, fakeChapter + (random.nextBool() ? 1 : -1));
      } else if (trickType == 1) {
        fakeVerse = max(1, fakeVerse + (random.nextInt(3) + 1));
      } else {
        fakeBook = random.nextInt(66) + 1; 
      }

      final fakeOpt = _RefOption(book: fakeBook, chapter: fakeChapter, verse: fakeVerse, isCorrect: false);
      if (!usedKeys.contains(fakeOpt.uniqueKey)) {
        _options.add(fakeOpt);
        usedKeys.add(fakeOpt.uniqueKey);
      }
    }

    _options.shuffle();
  }

  void _submitAnswer(_RefOption selectedOption) {
    _stopwatch.stop();
    final elapsedSeconds = _stopwatch.elapsed.inSeconds;

    int grade;
    if (selectedOption.isCorrect) {
      grade = elapsedSeconds <= 4 ? 5 : 4; 
    } else {
      grade = 0; 
    }

    if (!selectedOption.isCorrect && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.game_reference_incorrect),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final feedback = PracticeFeedback(
      verseId: widget.verse.id,
      grade: grade,
      durationSeconds: elapsedSeconds,
      gameType: GameType.referenceMatch,
    );

    ref.read(practiceSessionProvider.notifier).submitFeedback(feedback);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.game_reference_prompt,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  widget.verse.verseText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.0,
              physics: const NeverScrollableScrollPhysics(),
              children: _options.map((option) {
                return _ReferenceOptionButton(
                  option: option,
                  onTap: () => _submitAnswer(option),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceOptionButton extends ConsumerWidget {
  final _RefOption option;
  final VoidCallback onTap;

  const _ReferenceOptionButton({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookNameAsync = ref.watch(bookNameProvider(option.book));

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onTap,
      child: bookNameAsync.when(
        data: (name) => Text(
          "$name\n${option.chapter}:${option.verse}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Text(context.l10n.game_reference_bookFallback(option.book)),
      ),
    );
  }
}