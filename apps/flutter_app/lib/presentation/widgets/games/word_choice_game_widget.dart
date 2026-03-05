import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class WordChoiceGameWidget extends ConsumerStatefulWidget {
  final SavedVerse verse;

  const WordChoiceGameWidget({super.key, required this.verse});

  @override
  ConsumerState<WordChoiceGameWidget> createState() => _WordChoiceGameWidgetState();
}

class _WordChoiceGameWidgetState extends ConsumerState<WordChoiceGameWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  bool _isInitialized = false;
  
  late List<String> _words;
  late List<int> _blankIndices;
  late List<String> _globalDictionary; 
  
  int _currentStep = 0;
  late List<String> _currentOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _setupGame();
      _stopwatch.start();
      _isInitialized = true;
    }
  }

  void _setupGame() {
    _words = widget.verse.verseText.trim().split(RegExp(r'\s+'));
    if (_words.isEmpty) {
      _words = [
        context.l10n.game_wordChoice_errorFallback1, 
        context.l10n.game_wordChoice_errorFallback2, 
        context.l10n.game_wordChoice_errorFallback3
      ];
    }

    _blankIndices = [];
    
    // Hide every 3rd word
    for (int i = 2; i < _words.length; i += 3) {
      _blankIndices.add(i);
    }

    // Fallbacks for extremely short verses
    if (_blankIndices.isEmpty && _words.length > 1) {
      _blankIndices.add(_words.length - 1);
    } else if (_blankIndices.isEmpty) {
      _blankIndices.add(0);
    }

    _buildGlobalDictionary();
    _generateOptionsForCurrentStep();
  }

  void _buildGlobalDictionary() {
    final allVerses = ref.read(savedVersesControllerProvider).value ?? [];
    final Set<String> uniqueWords = {};

    for (final v in allVerses) {
      if (v.id == widget.verse.id) continue;

      final words = v.verseText.split(RegExp(r'\s+'));
      for (var w in words) {
        final clean = w.replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '').trim();
        if (clean.length > 2) {
          uniqueWords.add(clean);
        }
      }
    }

    _globalDictionary = uniqueWords.toList();
    _globalDictionary.shuffle();
  }

  void _generateOptionsForCurrentStep() {
    final targetIndex = _blankIndices[_currentStep];
    final correctWord = _words[targetIndex].replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '');

    // 1. Try to get fake words from the CURRENT verse first
    final dummyPool = _words
        .asMap()
        .entries
        .where((e) => e.key != targetIndex)
        .map((e) => e.value.replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), ''))
        .where((w) => w.length > 2)
        .toList();
        
    dummyPool.shuffle();

    _currentOptions = [correctWord];
    
    // 2. Fill options from the current verse
    while (_currentOptions.length < 4 && dummyPool.isNotEmpty) {
      final dummy = dummyPool.removeLast();
      if (!_currentOptions.contains(dummy)) _currentOptions.add(dummy);
    }

    // 3. If the verse is too short, pull from the dynamic global dictionary
    int dictIndex = 0;
    while (_currentOptions.length < 4 && dictIndex < _globalDictionary.length) {
      final fallback = _globalDictionary[dictIndex];
      if (!_currentOptions.contains(fallback)) _currentOptions.add(fallback);
      dictIndex++;
    }

    // Shuffle so the correct answer isn't always top-left
    _currentOptions.shuffle();
  }

  void _submitAnswer(String selectedWord) {
    final targetIndex = _blankIndices[_currentStep];
    final correctWord = _words[targetIndex].replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '');

    if (selectedWord == correctWord) {
      setState(() {
        _currentStep++;
      });

      if (_currentStep >= _blankIndices.length) {
        _stopwatch.stop();
        final elapsedSeconds = _stopwatch.elapsed.inSeconds;
        
        final targetPerfectTime = _blankIndices.length * 3;
        final grade = elapsedSeconds <= targetPerfectTime ? 5 : 4;

        _finishGame(grade, elapsedSeconds);
      } else {
        setState(() {
          _generateOptionsForCurrentStep();
        });
      }
    } else {
      // FAIL
      _stopwatch.stop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.game_wordChoice_incorrect(correctWord)),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }

      _finishGame(0, _stopwatch.elapsed.inSeconds);
    }
  }

  void _finishGame(int grade, int duration) {
    final feedback = PracticeFeedback(
      verseId: widget.verse.id,
      grade: grade,
      durationSeconds: duration,
      gameType: GameType.wordChoice,
    );
    ref.read(practiceSessionProvider.notifier).submitFeedback(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.game_wordChoice_prompt(_currentStep + 1, _blankIndices.length),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0, 
                runSpacing: 12.0,
                alignment: WrapAlignment.center,
                children: _words.asMap().entries.map((entry) {
                  final index = entry.key;
                  final word = entry.value;

                  if (_blankIndices.contains(index)) {
                    final blankOrder = _blankIndices.indexOf(index);
                    
                    if (blankOrder < _currentStep) {
                      return Text(word, style: theme.textTheme.titleLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold));
                    } else if (blankOrder == _currentStep) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.primary, width: 2),
                        ),
                        child: const Text("?", style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    } else {
                      return Text("_____", style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey.shade400));
                    }
                  }

                  return Text(word, style: theme.textTheme.titleLarge);
                }).toList(),
              ),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              physics: const NeverScrollableScrollPhysics(),
              children: _currentOptions.map((option) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _submitAnswer(option),
                  child: Text(
                    option, 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}