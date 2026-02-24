import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';

// Represents a clickable word in the word bank
class _WordOption {
  final String id; // Unique ID to handle duplicate words
  final String text;

  _WordOption({required this.id, required this.text});
}

class VerseBuilderGameWidget extends ConsumerStatefulWidget {
  final SavedVerse verse;

  const VerseBuilderGameWidget({super.key, required this.verse});

  @override
  ConsumerState<VerseBuilderGameWidget> createState() => _VerseBuilderGameWidgetState();
}

class _VerseBuilderGameWidgetState extends ConsumerState<VerseBuilderGameWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  
  late List<String> _rawWords;      // Original words with punctuation (e.g., "God,")
  late List<String> _targetWords;   // Cleaned words to match against (e.g., "God")
  
  List<_WordOption> _wordBank = []; // The buttons at the bottom
  int _currentIndex = 0;            // Which word we are currently guessing
  int _mistakes = 0;

  @override
  void initState() {
    super.initState();
    _setupGame();
    _stopwatch.start();
  }

  void _setupGame() {
    _rawWords = widget.verse.verseText.trim().split(RegExp(r'\s+'));
    if (_rawWords.isEmpty) _rawWords = ["Error"];

    _targetWords = [];
    final List<_WordOption> correctOptions = [];

    // 1. Process actual words
    for (int i = 0; i < _rawWords.length; i++) {
      // Strip punctuation for matching, but keep the original case
      final cleanWord = _rawWords[i].replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '');
      _targetWords.add(cleanWord);
      
      correctOptions.add(_WordOption(id: 'correct_$i', text: cleanWord));
    }

    // 2. Add some "dummy" words from other verses to make it harder
    final dummyOptions = _getDummyWords(count: 4);
    
    // 3. Combine and shuffle the word bank
    _wordBank = [...correctOptions, ...dummyOptions];
    _wordBank.shuffle();
  }

  List<_WordOption> _getDummyWords({required int count}) {
    final allVerses = ref.read(savedVersesControllerProvider).value ?? [];
    final Set<String> uniqueDummies = {};

    for (final v in allVerses) {
      if (v.id == widget.verse.id) continue;
      
      final words = v.verseText.split(RegExp(r'\s+'));
      for (var w in words) {
        final clean = w.replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '').trim();
        if (clean.length > 2 && !_targetWords.contains(clean)) {
          uniqueDummies.add(clean);
        }
      }
    }

    final dummyList = uniqueDummies.toList()..shuffle();
    final selectedDummies = dummyList.take(count).toList();
    
    // Fallback if user has no other verses
    if (selectedDummies.isEmpty) {
      selectedDummies.addAll(["Lord", "grace", "faith", "holy"]);
    }

    return List.generate(
      selectedDummies.length, 
      (i) => _WordOption(id: 'dummy_$i', text: selectedDummies[i])
    );
  }

  void _onWordSelected(_WordOption option) {
    // Check if the text matches the current expected word (case-insensitive for fairness)
    final expectedWord = _targetWords[_currentIndex].toLowerCase();
    
    if (option.text.toLowerCase() == expectedWord) {
      // SUCCESS: Move word from bank to built sentence
      setState(() {
        _wordBank.removeWhere((w) => w.id == option.id);
        _currentIndex++;
      });

      if (_currentIndex >= _rawWords.length) {
        _finishSession();
      }
    } else {
      // MISTAKE
      setState(() {
        _mistakes++;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not quite! Try a different word."),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  void _finishSession() {
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsed.inSeconds;

    int grade;
    if (_mistakes == 0) {
      grade = 5; // Perfect
    } else if (_mistakes <= 2) {
      grade = 4; // Minor hesitations
    } else if (_mistakes <= (_rawWords.length / 2)) {
      grade = 3; // Passed, but struggled
    } else {
      grade = 2; // Too many blind guesses. Force them to review it.
    }

    final feedback = PracticeFeedback(
      verseId: widget.verse.id,
      grade: grade,
      durationSeconds: elapsed,
      gameType: GameType.verseBuilder,
    );

    ref.read(practiceSessionProvider.notifier).submitFeedback(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookNameAsync = ref.watch(bookNameProvider(widget.verse.book));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- HEADER & REFERENCE ---
            bookNameAsync.when(
              data: (name) => Text(
                "$name ${widget.verse.chapter}:${widget.verse.verse}",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 8),
            Text(
              "Build the verse:",
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
      
            // --- BUILT SENTENCE AREA ---
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 12.0,
                    children: List.generate(_rawWords.length, (index) {
                      if (index < _currentIndex) {
                        // Words already correctly guessed (shows original punctuation!)
                        return Text(
                          _rawWords[index], 
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                        );
                      } else if (index == _currentIndex) {
                        // Active slot
                        return Container(
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 3)),
                          ),
                          child: Text(" ", style: theme.textTheme.headlineSmall),
                        );
                      } else {
                        // Future slots
                        return Text(
                          "_", 
                          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey.shade400),
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
      
            // --- WORD BANK (BUTTONS) ---
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  alignment: WrapAlignment.center,
                  children: _wordBank.map((option) {
                    return ActionChip(
                      label: Text(
                        option.text, 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                      ),
                      backgroundColor: theme.colorScheme.surface,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      onPressed: () => _onWordSelected(option),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}