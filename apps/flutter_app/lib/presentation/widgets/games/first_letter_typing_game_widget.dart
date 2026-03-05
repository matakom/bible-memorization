import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class _WordTarget {
  final String originalText; 
  final String? targetLetter; 
  final int length; 
  bool isRevealed;

  _WordTarget({
    required this.originalText,
    required this.targetLetter,
    required this.length,
    this.isRevealed = false,
  });
}

class FirstLetterTypingGameWidget extends ConsumerStatefulWidget {
  final SavedVerse verse;

  const FirstLetterTypingGameWidget({super.key, required this.verse});

  @override
  ConsumerState<FirstLetterTypingGameWidget> createState() => _FirstLetterTypingGameWidgetState();
}

class _FirstLetterTypingGameWidgetState extends ConsumerState<FirstLetterTypingGameWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  late List<_WordTarget> _words;
  int _currentIndex = 0;
  
  int _mistakes = 0;
  int _hintsUsed = 0;
  late bool _isHardMode;

  @override
  void initState() {
    super.initState();
    _isHardMode = widget.verse.correctCount >= 3; 
    _setupGame();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    
    _stopwatch.start();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  // Maps Czech/international diacritics to their base characters
  String _normalizeChar(String input) {
    const withDia = 'áäčďéěíňóöřšťúůüýž';
    const withoutDia = 'aacdeeinoorstuuuyz';
    
    String result = input.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result;
  }

  void _setupGame() {
    final rawWords = widget.verse.verseText.trim().split(RegExp(r'\s+'));
    _words = [];

    final letterRegExp = RegExp(r'[a-zA-Zá-žÁ-Ž]');

    for (var w in rawWords) {
      final match = letterRegExp.firstMatch(w);
      // NORMALIZE THE TARGET LETTER:
      final target = match != null ? _normalizeChar(match.group(0)!) : null;
      
      final letterLength = w.replaceAll(RegExp(r'[^\w]'), '').length;

      _words.add(_WordTarget(
        originalText: w,
        targetLetter: target,
        length: letterLength > 0 ? letterLength : 1,
      ));
    }

    _skipNonLetters();
  }

  void _skipNonLetters() {
    while (_currentIndex < _words.length && _words[_currentIndex].targetLetter == null) {
      setState(() {
        _words[_currentIndex].isRevealed = true;
        _currentIndex++;
      });
    }
    if (_currentIndex >= _words.length) {
      _finishSession();
    }
  }

  void _handleInput(String input) {
    if (input.isEmpty || _currentIndex >= _words.length) return;

    // NORMALIZE THE TYPED LETTER:
    final typedChar = _normalizeChar(input.substring(input.length - 1));
    _textController.clear(); 

    final currentWord = _words[_currentIndex];

    if (typedChar == currentWord.targetLetter) {
      setState(() {
        currentWord.isRevealed = true;
        _currentIndex++;
      });
      _skipNonLetters(); 
    } else {
      setState(() {
        _mistakes++;
      });
    }
  }

  void _useHint() {
    if (_currentIndex >= _words.length) return;
    setState(() {
      _hintsUsed++;
      _words[_currentIndex].isRevealed = true;
      _currentIndex++;
    });
    _skipNonLetters();
    _focusNode.requestFocus(); 
  }

  void _finishSession() {
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsed.inSeconds;

    int grade;
    if (_hintsUsed > 0) {
      grade = 2; 
    } else if (_mistakes == 0) {
      grade = 5; 
    } else if (_mistakes <= (_words.length * 0.1).ceil()) {
      grade = 4; 
    } else {
      grade = 3; 
    }

    final feedback = PracticeFeedback(
      verseId: widget.verse.id,
      grade: grade,
      durationSeconds: elapsed,
      gameType: GameType.firstLetterTyping,
    );

    ref.read(practiceSessionProvider.notifier).submitFeedback(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // FETCH THE BOOK NAME
    final bookNameAsync = ref.watch(bookNameProvider(widget.verse.book));

    return Column(
      children: [
        // --- HEADER INFO ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isHardMode ? context.l10n.game_firstLetter_hardMode : context.l10n.game_firstLetter_easyMode,
                style: TextStyle(
                  color: _isHardMode ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                context.l10n.game_firstLetter_mistakes(_mistakes),
                style: TextStyle(color: _mistakes > 0 ? Colors.red : Colors.grey),
              ),
            ],
          ),
        ),

        // --- VERSE REFERENCE DISPLAY ---
        bookNameAsync.when(
          data: (name) => Text(
            "$name ${widget.verse.chapter}:${widget.verse.verse}",
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          loading: () => const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => const SizedBox.shrink(),
        ),
        
        const SizedBox(height: 16),

        // --- VERSE TEXT RENDERING ---
        Expanded(
          child: GestureDetector(
            onTap: () => _focusNode.requestFocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.center, 
                children: _words.asMap().entries.map((entry) {
                  final index = entry.key;
                  final word = entry.value;

                  if (word.isRevealed) {
                    return Text(
                      word.originalText,
                      style: theme.textTheme.headlineSmall,
                    );
                  } else if (index == _currentIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 3)),
                      ),
                      child: Text(
                        _isHardMode ? "_" : "_" * word.length,
                        style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                      ),
                    );
                  } else {
                    return Text(
                      _isHardMode ? "_" : "_" * word.length,
                      style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey.shade400),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        ),

        // --- CONTROLS & HIDDEN INPUT ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text, 
                  decoration: InputDecoration(
                    hintText: context.l10n.game_firstLetter_hintText,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _handleInput,
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: _useHint,
                icon: const Icon(Icons.lightbulb),
                tooltip: context.l10n.game_firstLetter_revealTooltip,
              )
            ],
          ),
        )
      ],
    );
  }
}