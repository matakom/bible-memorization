import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/reader_state_provider.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bibleBooksProvider);
    final readerState = ref.watch(readerProvider);

    return booksAsync.when(
      loading: () => Text(context.l10n.reader_loading, style: const TextStyle(fontSize: 14)),
      error: (_, __) => Text(context.l10n.reader_error, style: const TextStyle(fontSize: 14)),
      data: (books) {
        final currentBook = books.firstWhere(
          (b) => b.bookId == readerState.bookId,
          orElse: () => books.first,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // BOOK SELECTOR
              Expanded(
                flex: 5,
                child: _StyledDropdown(
                  value: currentBook.bookId,
                  items: books.map((b) => DropdownMenuItem(
                    value: b.bookId,
                    child: Text(b.bookName, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (id) {
                    if (id != null) ref.read(readerProvider.notifier).selectBook(id);
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // CHAPTER SELECTOR
              Expanded(
                flex: 3,
                child: _StyledDropdown(
                  value: readerState.chapterNum,
                  items: List.generate(currentBook.chapters.length, (i) {
                    return DropdownMenuItem(
                      value: i + 1,
                      // Simple number or "Ch. 1" format
                      child: Center(child: Text("${i + 1}")), 
                    );
                  }),
                  onChanged: (num) {
                    if (num != null) ref.read(readerProvider.notifier).selectChapter(num);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// Internal widget to make dropdowns look fancy
class _StyledDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // Uses the 'Surface Container High' color for a subtle standout
        color: Theme.of(context).colorScheme.surfaceContainerHigh, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.unfold_more, 
            color: Theme.of(context).colorScheme.onSurfaceVariant, 
            size: 18
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}