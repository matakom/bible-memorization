import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';

// Lightweight class to hold the option data
class _RefOption {
  final int book;
  final int chapter;
  final int verse;
  final bool isCorrect;

  _RefOption({required this.book, required this.chapter, required this.verse, required this.isCorrect});

  String get uniqueKey => '$book-$chapter-$verse';
}

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

    // 1. Add the correct option
    final correctOpt = _RefOption(
      book: widget.verse.book,
      chapter: widget.verse.chapter,
      verse: widget.verse.verse,
      isCorrect: true,
    );
    _options.add(correctOpt);
    usedKeys.add(correctOpt.uniqueKey);

    // 2. Try to pull wrong options from other saved verses
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

    // 3. If we STILL need options (e.g. user only has 1 verse saved), generate tricky fakes
    final random = Random();
    while (_options.length < 4) {
      // Create a fake reference by tweaking the correct verse's numbers
      int fakeBook = widget.verse.book;
      int fakeChapter = widget.verse.chapter;
      int fakeVerse = widget.verse.verse;

      final trickType = random.nextInt(3);
      if (trickType == 0) {
        // Same book, adjacent chapter
        fakeChapter = max(1, fakeChapter + (random.nextBool() ? 1 : -1));
      } else if (trickType == 1) {
        // Same book, same chapter, adjacent verse
        fakeVerse = max(1, fakeVerse + (random.nextInt(3) + 1));
      } else {
        // Totally different book, same chapter/verse
        fakeBook = random.nextInt(66) + 1; 
      }

      final fakeOpt = _RefOption(book: fakeBook, chapter: fakeChapter, verse: fakeVerse, isCorrect: false);
      if (!usedKeys.contains(fakeOpt.uniqueKey)) {
        _options.add(fakeOpt);
        usedKeys.add(fakeOpt.uniqueKey);
      }
    }

    // 4. Shuffle the final 4 options so the correct one isn't always first
    _options.shuffle();
  }

  void _submitAnswer(_RefOption selectedOption) {
    _stopwatch.stop();
    final elapsedSeconds = _stopwatch.elapsed.inSeconds;

    int grade;
    if (selectedOption.isCorrect) {
      // Fast recognition (<= 4s) = 5, Slower = 4
      grade = elapsedSeconds <= 4 ? 5 : 4; 
    } else {
      grade = 0; // Fail
    }

    if (!selectedOption.isCorrect && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect reference. Let's study this one again!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
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
          const Text(
            "Where is this verse found?",
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Display the Verse Text
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
          
          // 2x2 Grid for Options
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

// Dedicated widget to safely resolve the async Book Name from your DB
class _ReferenceOptionButton extends ConsumerWidget {
  final _RefOption option;
  final VoidCallback onTap;

  const _ReferenceOptionButton({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This perfectly fetches the localized book name (e.g. "Genesis", "1. Mojžíšova")
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
        error: (_, __) => Text("Book ${option.book}"),
      ),
    );
  }
}