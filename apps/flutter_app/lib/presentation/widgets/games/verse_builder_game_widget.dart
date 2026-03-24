import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/verse_text_provider.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

/// Internal model representing a word choice in the game's word bank.
class _WordOption {
  final String id; 
  final String text;

  _WordOption({required this.id, required this.text});
}

/// A practice mode where users reconstruct a verse by selecting words in the correct sequence, 
/// using contextual words from the same chapter as distractors.
class VerseBuilderGameWidget extends ConsumerStatefulWidget {
  final SavedVerse verse;

  const VerseBuilderGameWidget({super.key, required this.verse});

  @override
  ConsumerState<VerseBuilderGameWidget> createState() => _VerseBuilderGameWidgetState();
}

class _VerseBuilderGameWidgetState extends ConsumerState<VerseBuilderGameWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  bool _isInitialized = false;
  bool _isLoading = true;
  
  late List<String> _rawWords;      
  late List<String> _targetWords;   
  
  List<_WordOption> _wordBank = []; 
  int _currentIndex = 0;            
  int _mistakes = 0;

  Future<void> _setupGame(String verseText) async {
    if (_isInitialized) return;
    _isInitialized = true;

    _rawWords = verseText.trim().split(RegExp(r'\s+'));
    if (_rawWords.isEmpty) _rawWords = ["Error"];

    _targetWords = [];
    final List<_WordOption> correctOptions = [];

    for (int i = 0; i < _rawWords.length; i++) {
      final cleanWord = _rawWords[i].replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '');
      _targetWords.add(cleanWord);
      correctOptions.add(_WordOption(id: 'correct_$i', text: cleanWord));
    }

    final dummyOptions = await _getDummyWords(count: 4);
    
    if (mounted) {
      setState(() {
        _wordBank = [...correctOptions, ...dummyOptions];
        _wordBank.shuffle();
        _isLoading = false;
        _stopwatch.start();
      });
    }
  }

  Future<List<_WordOption>> _getDummyWords({required int count}) async {
    final Set<String> uniqueDummies = {};
    
    try {
      final repository = ref.read(bibleRepositoryProvider);
      final chapter = await repository.getChapter(widget.verse.book, widget.verse.chapter);
      
      final targetLower = _targetWords.map((w) => w.toLowerCase()).toSet();

      for (final v in chapter.verses) {
        if (v.verseNumber == widget.verse.verse) continue;
        
        final words = v.text.split(RegExp(r'\s+'));
        for (var w in words) {
          final clean = w.replaceAll(RegExp(r'[.,;!?":\(\)\[\]]'), '').trim();
          if (clean.length > 2 && !targetLower.contains(clean.toLowerCase())) {
            uniqueDummies.add(clean);
          }
        }
        if (uniqueDummies.length >= count + 10) break;
      }
    } catch (_) {}

    final dummyList = uniqueDummies.toList()..shuffle();
    final selectedDummies = dummyList.take(count).toList();
    
    return List.generate(
      selectedDummies.length, 
      (i) => _WordOption(id: 'dummy_$i', text: selectedDummies[i])
    );
  }

  void _onWordSelected(_WordOption option) {
    final expectedWord = _targetWords[_currentIndex].toLowerCase();
    
    if (option.text.toLowerCase() == expectedWord) {
      setState(() {
        _wordBank.removeWhere((w) => w.id == option.id);
        _currentIndex++;
      });

      if (_currentIndex >= _rawWords.length) {
        _finishSession();
      }
    } else {
      setState(() {
        _mistakes++;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.game_builder_incorrect),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 600),
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
      grade = 5; 
    } else if (_mistakes <= 2) {
      grade = 4; 
    } else if (_mistakes <= (_rawWords.length / 2)) {
      grade = 3; 
    } else {
      grade = 2; 
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
    final verseRef = VerseRef(bookId: widget.verse.book, chapter: widget.verse.chapter, verse: widget.verse.verse);
    final textAsync = ref.watch(verseTextProvider(verseRef));

    return textAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Icon(Icons.error, color: Colors.red)),
      data: (verseText) {
        if (!_isInitialized) {
          Future.microtask(() => _setupGame(verseText));
          return const Center(child: CircularProgressIndicator());
        }

        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final theme = Theme.of(context);
        final bookNameAsync = ref.watch(bookNameProvider(widget.verse.book));

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  context.l10n.game_builder_prompt,
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
          
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
                            return Text(
                              _rawWords[index], 
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                            );
                          } else if (index == _currentIndex) {
                            return Container(
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 3)),
                              ),
                              child: const Text(" ", style: TextStyle(fontSize: 24)),
                            );
                          } else {
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
      },
    );
  }
}