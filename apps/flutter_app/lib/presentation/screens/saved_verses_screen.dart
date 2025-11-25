import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_app/providers/reader/verse_text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';

class SavedVersesScreen extends ConsumerWidget {
  const SavedVersesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedVersesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reader_savedVersesTitle),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('${context.l10n.reader_errorLoadingSavedVerses}$err'),
              TextButton(
                onPressed: () => ref.invalidate(savedVersesControllerProvider),
                child: Text(context.l10n.reader_retrySavedVersesFetch),
              ),
            ],
          ),
        ),
        data: (verses) {
          if (verses.isEmpty) {
            return Center(
              child: Text(
                context.l10n.reader_noSavedVersesYet,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: verses.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
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
    final verseRef = VerseRef(
      bookId: verse.book,
      chapter: verse.chapter,
      verse: verse.verse,
    );

    final textAsync = ref.watch(verseTextProvider(verseRef));
    final bookNameAsync = ref.watch(bookNameProvider(verse.book));

    return Dismissible(
      key: Key(verse.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(savedVersesControllerProvider.notifier).deleteVerse(verse.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bookNameAsync.when(
                    data: (bookName) => Text(
                      '$bookName ${verse.chapter}:${verse.verse}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    loading: () => CircularProgressIndicator(),
                    error: (_, __) => Text('Book ${verse.book}'),
                  ),
                  _DifficultyBadge(difficulty: verse.difficulty),
                ],
              ),
              const SizedBox(height: 12),

              textAsync.when(
                loading: () => const SizedBox(
                  height: 16,
                  width: 150,
                  child: LinearProgressIndicator(),
                ),
                error: (err, _) => const Text(
                  'Verse not found',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                data: (text) => Text(
                  text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final int difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    // Simple color coding for difficulty (1-5)
    final color = switch (difficulty) {
      1 => Colors.green,
      2 => Colors.lightGreen,
      3 => Colors.orange,
      4 => Colors.deepOrange,
      _ => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        'Lvl $difficulty',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
