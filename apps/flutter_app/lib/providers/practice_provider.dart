import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/saved_verse.dart';
import '../data/local/enums.dart'; 
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/saved_verses_repository.dart';
import 'core/repository_providers.dart';

// Necessary for code generation to work
part 'practice_provider.g.dart';

// --- STATE (Unchanged) ---
class PracticeSessionState {
  // ... (Keep your existing state class exactly as it is) ...
  final bool isLoading;
  final List<SavedVerse> queue;
  final int currentIndex;
  final bool isAnswerRevealed;
  final bool isSessionComplete;
  final DateTime? cardStartTime; 

  const PracticeSessionState({
    this.isLoading = true,
    this.queue = const [],
    this.currentIndex = 0,
    this.isAnswerRevealed = false,
    this.isSessionComplete = false,
    this.cardStartTime,
  });

  PracticeSessionState copyWith({
    bool? isLoading,
    List<SavedVerse>? queue,
    int? currentIndex,
    bool? isAnswerRevealed,
    bool? isSessionComplete,
    DateTime? cardStartTime,
  }) {
    return PracticeSessionState(
      isLoading: isLoading ?? this.isLoading,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      cardStartTime: cardStartTime ?? this.cardStartTime,
    );
  }

  SavedVerse? get currentVerse => (queue.isNotEmpty && currentIndex < queue.length) 
      ? queue[currentIndex] 
      : null;
}

// --- NEW NOTIFIER SYNTAX ---
// Using @riverpod automatically creates an AutoDisposeNotifier
@riverpod
class PracticeSession extends _$PracticeSession {
  
  @override
  PracticeSessionState build() {
    // In generated notifiers, we usually fire the setup separately 
    // or inside the build if it's synchronous. 
    // Ideally, avoid side-effects in build(), but for this logic:
    Future.microtask(() => startSession());
    return const PracticeSessionState(isLoading: true);
  }

  Future<void> startSession() async {
    // 'ref' is available automatically in generated classes
    final versesRepo = ref.read(savedVersesRepositoryProvider);

    state = state.copyWith(isLoading: true, isSessionComplete: false, currentIndex: 0, queue: []);
    
    try {
      final verses = await versesRepo.getDueVersesForSession();
      
      if (verses.isEmpty) {
        state = state.copyWith(isLoading: false, isSessionComplete: true);
      } else {
        state = state.copyWith(
          isLoading: false, 
          queue: verses, 
          currentIndex: 0,
          isAnswerRevealed: false,
          cardStartTime: DateTime.now(),
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isSessionComplete: true);
    }
  }

  void revealAnswer() {
    state = state.copyWith(isAnswerRevealed: true);
  }

  Future<void> rateVerse(int grade) async {
    // Note: In generated code, use 'state' directly (it is the value)
    final currentVerse = state.currentVerse;
    if (currentVerse == null) return;

    final now = DateTime.now();
    final duration = now.difference(state.cardStartTime ?? now).inMilliseconds;

    try {
      final exerciseRepo = ref.read(exerciseRepositoryProvider);
      final versesRepo = ref.read(savedVersesRepositoryProvider);

      await exerciseRepo.saveResult(
        savedVerseId: currentVerse.id,
        gameType: GameType.firstLetter, 
        score: grade.toDouble(),
        durationMs: duration,
      );

      await versesRepo.updateVerseProgress(currentVerse, grade);

      final nextIndex = state.currentIndex + 1;
      
      if (nextIndex >= state.queue.length) {
        state = state.copyWith(isSessionComplete: true);
      } else {
        state = state.copyWith(
          currentIndex: nextIndex,
          isAnswerRevealed: false,
          cardStartTime: DateTime.now(),
        );
      }
    } catch (e) {
      // Handle error
    }
  }
}