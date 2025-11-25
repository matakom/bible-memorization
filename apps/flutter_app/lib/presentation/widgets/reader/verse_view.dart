import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/reader_state_provider.dart';
import 'package:flutter_app/providers/reader/verse_selection_provider.dart';

class ReaderContentView extends ConsumerWidget {
  const ReaderContentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerState = ref.watch(readerProvider);
    
    final chapterAsync = ref.watch(
      chapterContentProvider(ChapterRef(readerState.bookId, readerState.chapterNum))
    );

    final savedVersesState = ref.watch(savedVersesControllerProvider);
    
    final savedVerseNumbers = savedVersesState.value 
        ?.where((v) => 
            v.book == readerState.bookId && 
            v.chapter == readerState.chapterNum
        )
        .map((v) => v.verse)
        .toSet() ?? {};

    return chapterAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${context.l10n.reader_error}: $err')),
      data: (chapter) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
          itemCount: chapter.verses.length,
          itemBuilder: (context, index) {
            final verse = chapter.verses[index];
            final verseNum = verse.verseNumber;

            final isSelected = ref.watch(verseSelectionProvider).contains(verseNum);
            final isSaved = savedVerseNumbers.contains(verseNum);

            return _VerseItem(
              verseNum: verseNum,
              text: verse.text,
              isSelected: isSelected,
              isSaved: isSaved,
              onTap: () => ref.read(verseSelectionProvider.notifier).toggle(verseNum),
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
  final bool isSaved; 
  final VoidCallback onTap;

  const _VerseItem({
    required this.verseNum,
    required this.text,
    required this.isSelected,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine background color based on priority:
    // 1. Selected (Active interaction) -> Primary Color
    // 2. Saved (Passive state) -> Tertiary/Secondary Color
    // 3. None -> Transparent
    Color? backgroundColor;
    if (isSelected) {
      backgroundColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.5);
    } else if (isSaved) {
      backgroundColor = theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3);
    } else {
      backgroundColor = Colors.transparent;
    }

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Number Column
            SizedBox(
              width: 32,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Text(
                      "$verseNum",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        // Highlight number color if saved
                        color: isSaved || isSelected
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    // Icon to indicate it is saved
                    if (isSaved && !isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.bookmark_rounded, 
                          size: 10, 
                          color: theme.colorScheme.tertiary,
                        ),
                      )
                  ],
                ),
              ),
            ),
            // Verse Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}