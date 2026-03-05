import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/providers/reader/saved_verses_provider.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';

class SavedVersesScreen extends ConsumerWidget {
  const SavedVersesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(currentSavedVersesProvider);
    final currentTranslation = ref.watch(currentBibleTranslationProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('${context.l10n.reader_savedVersesTitle} (${currentTranslation?.abbreviation ?? ''})'),
      ),
      body: versesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('${context.l10n.reader_errorLoadingSavedVerses}\n$err', textAlign: TextAlign.center),
              TextButton(
                // Invalidate the specific provider to retry
                onPressed: () => ref.invalidate(currentSavedVersesProvider),
                child: Text(context.l10n.reader_retrySavedVersesFetch),
              ),
            ],
          ),
        ),
        data: (verses) {
          if (verses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmarks_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.reader_noSavedVersesYet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.savedVerses_currentTranslation(currentTranslation?.abbreviation ?? ''),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: verses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4), // Small gap between cards
            itemBuilder: (context, index) {
              final verse = verses[index];
              return _SavedVerseTile(verse: verse);
            },
          );
        },
      ),
    );
  }
}

class _SavedVerseTile extends ConsumerWidget {
  final SavedVerse verse;

  const _SavedVerseTile({required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookNameAsync = ref.watch(bookNameProvider(verse.book));

    return Dismissible(
      key: Key(verse.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.red.withOpacity(0.9),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        ref.read(savedVersesControllerProvider.notifier).deleteVerse(verse.id);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(context.l10n.savedVerses_verseDeleted), duration: const Duration(seconds: 2)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Reference + Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: bookNameAsync.when(
                      data: (bookName) => Text(
                        '$bookName ${verse.chapter}:${verse.verse}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      loading: () => const SizedBox(
                        width: 80, 
                        height: 16, 
                        child: LinearProgressIndicator(minHeight: 2), // Subtle loading
                      ),
                      error: (_, __) => Text(
                        context.l10n.savedVerses_bookFallback(verse.book, verse.chapter, verse.verse),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _DifficultyBadge(difficulty: _calculateDifficultyLevel(verse.easeFactor)),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                verse.verseText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  int _calculateDifficultyLevel(double easeFactor) {
    if (easeFactor > 2.8) return 1; // Very Easy
    if (easeFactor > 2.5) return 2; // Easy
    if (easeFactor > 2.2) return 3; // Medium
    if (easeFactor > 1.9) return 4; // Hard
    return 5; // Very Hard
  }
}

class _DifficultyBadge extends StatelessWidget {
  final int difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      1 => Colors.green,       // Easy
      2 => Colors.lightGreen,
      3 => Colors.orange,      // Medium
      4 => Colors.deepOrange,
      _ => Colors.red,         // Hard
    };
    
    // Localize the labels using the BuildContext
    final label = switch (difficulty) {
      1 => context.l10n.savedVerses_difficultyEasy,
      2 => context.l10n.savedVerses_difficultyNormal,
      3 => context.l10n.savedVerses_difficultyModerate,
      4 => context.l10n.savedVerses_difficultyHard,
      _ => context.l10n.savedVerses_difficultyElite,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}