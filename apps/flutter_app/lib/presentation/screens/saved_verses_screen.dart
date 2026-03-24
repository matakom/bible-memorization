import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/providers/reader/saved_verses_provider.dart';
import 'package:flutter_app/providers/reader/verse_text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/providers/practice/practice_session_controller.dart';

/// Screen displaying all verses currently saved by the user in the selected translation.
class SavedVersesScreen extends ConsumerWidget {
  const SavedVersesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, _) {
        final versesAsync = ref.watch(currentSavedVersesProvider);
        final currentTranslation = ref
            .watch(currentBibleTranslationProvider)
            .value;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${context.l10n.reader_savedVersesTitle} (${currentTranslation?.abbreviation ?? ''})',
            ),
          ),
          body: versesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    '${context.l10n.reader_errorLoadingSavedVerses}\n$err',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
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
                      const Icon(
                        Icons.bookmarks_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.reader_noSavedVersesYet,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.savedVerses_currentTranslation(
                          currentTranslation?.abbreviation ?? '',
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: verses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return _SavedVerseTile(verse: verse);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _SavedVerseTile extends ConsumerWidget {
  final SavedVerse verse;

  const _SavedVerseTile({required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookNameAsync = ref.watch(bookNameProvider(verse.book));

    final verseRef = VerseRef(
      bookId: verse.book, 
      chapter: verse.chapter, 
      verse: verse.verse,
    );
    final textAsync = ref.watch(verseTextProvider(verseRef));

    return Dismissible(
      key: Key(verse.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.red.withValues(alpha: 0.9),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        ref.read(savedVersesControllerProvider.notifier).deleteVerse(verse.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.savedVerses_verseDeleted),
            duration: const Duration(seconds: 2),
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: bookNameAsync.when(
                      data: (bookName) => Text(
                        '$bookName ${verse.chapter}:${verse.verse}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      loading: () => const SizedBox(
                        width: 80,
                        height: 16,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                      error: (_, __) => Text(
                        context.l10n.savedVerses_bookFallback(
                          verse.book,
                          verse.chapter,
                          verse.verse,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                  child: textAsync.when(
                    data: (text) => Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(
                      context.l10n.game_flashcard_errorLoadText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      ref
                          .read(practiceSessionProvider.notifier)
                          .startInfiniteSession(verse);
                      context.push('/practice_shell');
                    },
                    icon: const Icon(Icons.repeat_rounded),
                    label: Text(context.l10n.practice_startSession),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
