import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/reader_state_provider.dart';
import 'package:flutter_app/providers/reader/verse_selection_provider.dart';

class ReaderContentView extends ConsumerWidget {
  const ReaderContentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readerProvider);
    
    // Fetch specific chapter data
    final chapterAsync = ref.watch(
      chapterContentProvider(ChapterRef(state.bookId, state.chapterNum))
    );

    return chapterAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${context.l10n.reader_error}: $err')),
      data: (chapter) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
          itemCount: chapter.verses.length,
          itemBuilder: (context, index) {
            final verse = chapter.verses[index];
            final isSelected = ref.watch(verseSelectionProvider).contains(verse.verseNumber);

            return _VerseItem(
              verseNum: verse.verseNumber,
              text: verse.text,
              isSelected: isSelected,
              onTap: () => ref.read(verseSelectionProvider.notifier).toggle(verse.verseNumber),
            );
          },
        );
      },
    );
  }
}
class _VerseItem extends StatelessWidget {
  final int verseNum;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _VerseItem({
    required this.verseNum,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      // Smooth color transition
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        color: isSelected 
            ? theme.colorScheme.primaryContainer.withOpacity(0.5) 
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Number (Small and subtle)
            SizedBox(
              width: 32,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "$verseNum",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            // Verse Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17, // Readable size
                  height: 1.6,  // Good leading (line-height) for reading
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                  // Optional: font family if you have one configured
                  // fontFamily: 'Serif', 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}