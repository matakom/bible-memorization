import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/repositories/practice_repository.dart';
import 'package:flutter_app/providers/reader/verse_text_provider.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';

class FlashcardPracticeScreen extends ConsumerStatefulWidget {
  final List<SavedVerse> versesToPractice;

  const FlashcardPracticeScreen({super.key, required this.versesToPractice});

  @override
  ConsumerState<FlashcardPracticeScreen> createState() => _FlashcardPracticeScreenState();
}

class _FlashcardPracticeScreenState extends ConsumerState<FlashcardPracticeScreen> {
  late List<SavedVerse> _practiceQueue;
  
  bool _isFlipped = false;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _practiceQueue = List.from(widget.versesToPractice);
    _stopwatch.start();
  }

  void _handleGrade(int grade) async {
    _stopwatch.stop();
    
    final currentVerse = _practiceQueue.first;
    
    final result = PracticeResult(
      verseId: currentVerse.id,
      grade: grade,
      exerciseType: 'flashcard',
      durationSeconds: _stopwatch.elapsed.inSeconds,
    );

    ref.read(practiceRepositoryProvider.future).then((repo) {
      repo.submitSession([result]);
    }).catchError((e) {
      debugPrint("Error submitting grade: $e");
    });
    ref.invalidate(savedVersesControllerProvider);
    ref.invalidate(myStatsProvider);
    setState(() {
      _practiceQueue.removeAt(0);

      if (grade < 3) {
        _practiceQueue.add(currentVerse);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Marked for review. You'll see this again soon!"),
            duration: Duration(milliseconds: 500),
          ),
        );
      } 

      _isFlipped = false;
      _stopwatch.reset();
      _stopwatch.start();
    });

    if (_practiceQueue.isEmpty) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session Complete! Great job!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_practiceQueue.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final verse = _practiceQueue.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Remaining: ${_practiceQueue.length}'), 
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isFlipped) setState(() => _isFlipped = true);
              },
              child: Center(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(24),
                    child: _isFlipped 
                        ? _BackSide(verse: verse) 
                        : _FrontSide(verse: verse),
                  ),
                ),
              ),
            ),
          ),
          if (_isFlipped)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("Rate your recall:", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Fail Grades (0-2) -> Will Repeat
                      _GradeButton(grade: 0, color: Colors.black, label: '0', onTap: () => _handleGrade(0)),
                      _GradeButton(grade: 1, color: Colors.red.shade900, label: '1', onTap: () => _handleGrade(1)),
                      _GradeButton(grade: 2, color: Colors.red, label: '2', onTap: () => _handleGrade(2)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pass Grades (3-5) -> Will Finish
                      _GradeButton(grade: 3, color: Colors.green.shade300, label: '3', onTap: () => _handleGrade(3)),
                      _GradeButton(grade: 4, color: Colors.green, label: '4', onTap: () => _handleGrade(4)),
                      _GradeButton(grade: 5, color: Colors.blue, label: '5', onTap: () => _handleGrade(5)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("Tap card to show answer", style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }
}

// --- UPDATED WIDGETS ---

class _FrontSide extends ConsumerWidget {
  final SavedVerse verse;
  const _FrontSide({required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = verse.book;
    final bookNameAsync = ref.watch(bookNameProvider(bookId));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.help_outline, size: 48, color: Colors.grey),
        const SizedBox(height: 20),
        
        bookNameAsync.when(
          data: (name) => Text(
            "$name ${verse.chapter}:${verse.verse}",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => Text("There was an error!"),
        ),
        
        const SizedBox(height: 10),
        Text(verse.translation, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _BackSide extends ConsumerWidget {
  final SavedVerse verse;
  const _BackSide({required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = verse.book;
    
    final verseRef = VerseRef(
      bookId: bookId,
      chapter: verse.chapter,
      verse: verse.verse,
    );
    final textAsync = ref.watch(verseTextProvider(verseRef));
    
    final bookNameAsync = ref.watch(bookNameProvider(bookId));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        bookNameAsync.when(
          data: (name) => Text(
            "$name ${verse.chapter}:${verse.verse}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 20),
        
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: textAsync.when(
                data: (text) => Text(
                  text,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => const Text("Could not load text"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradeButton extends StatelessWidget {
  final int grade;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _GradeButton({required this.grade, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}