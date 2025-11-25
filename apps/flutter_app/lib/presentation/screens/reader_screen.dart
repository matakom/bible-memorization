import 'package:flutter/material.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/screens/saved_verses_screen.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/reader_state_provider.dart';
import 'package:flutter_app/providers/reader/verse_selection_provider.dart';
import 'package:flutter_app/presentation/widgets/reader/top_bar.dart';
import 'package:flutter_app/presentation/widgets/reader/verse_view.dart';

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVerses = ref.watch(verseSelectionProvider);

    // Clear selection if the user navigates to a different book/chapter
    ref.listen(readerProvider, (prev, next) {
      if (prev?.bookId != next.bookId || prev?.chapterNum != next.chapterNum) {
        ref.read(verseSelectionProvider.notifier).clear();
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const TopBar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_rounded),
            tooltip: context.l10n.reader_savedVersesTitle,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SavedVersesScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const ReaderContentView(),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: selectedVerses.isNotEmpty
            ? FloatingActionButton.extended(
                // Unique key for animation to work
                key: const ValueKey('save_fab'),
                onPressed: () => _showSaveDialog(context, ref, selectedVerses),
                icon: const Icon(Icons.bookmark_add_rounded),
                label: Text(
                  context.l10n.reader_saveButton(selectedVerses.length),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _showSaveDialog(
    BuildContext context,
    WidgetRef ref,
    Set<int> selectedVerses,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.reader_saveDialogTitle),
        content: Text(context.l10n.reader_saveDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.reader_cancel),
          ),
          FilledButton(
            onPressed: () async {
              final readerState = ref.read(readerProvider);

              final sortedVerses = selectedVerses.toList()..sort();
              
              final versesToSave = sortedVerses.map((verseNum) {
                return VerseCreationPayload(
                  book: readerState.bookId, 
                  chapter: readerState.chapterNum,
                  verse: verseNum,
                  translation: readerState.translation, 
                );
              }).toList();

              Navigator.pop(ctx);
              
              ref.read(verseSelectionProvider.notifier).clear();

              try {
                await ref
                    .read(savedVersesControllerProvider.notifier)
                    .addVerses(versesToSave);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n.reader_savedVerses(versesToSave.length),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error saving verses: ${e.toString()}"),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: Text(context.l10n.reader_confirm),
          ),
        ],
      ),
    );
  }
}
