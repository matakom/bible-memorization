import 'package:flutter/material.dart';
import 'package:flutter_app/config/bible_translations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_dimens.dart';
// Ensure this import points to where you defined your translation constants

class BibleNavHeader extends StatelessWidget {
  // Translation Props
  final String selectedTranslationId;
  final Function(String) onTranslationChanged;

  // Book Props
  final int selectedBookId;
  final Function(int) onBookChanged;
  final AsyncValue<List<dynamic>> booksAsync;

  // Chapter Props
  final int selectedChapter;
  final Function(int) onChapterChanged;

  const BibleNavHeader({
    super.key,
    required this.selectedTranslationId,
    required this.onTranslationChanged,
    required this.selectedBookId,
    required this.onBookChanged,
    required this.booksAsync,
    required this.selectedChapter,
    required this.onChapterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.s,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TRANSLATION SELECTOR (Flex 2)
          Expanded(
            flex: 2,
            child: _TranslationSelector(
              selectedId: selectedTranslationId,
              onChanged: onTranslationChanged,
            ),
          ),

          const SizedBox(width: AppSpacings.s),

          // 2. BOOK SELECTOR (Flex 3)
          Expanded(
            flex: 3,
            child: _BookSelector(
              selectedBookId: selectedBookId,
              booksAsync: booksAsync,
              onChanged: onBookChanged,
            ),
          ),

          const SizedBox(width: AppSpacings.s),

          // 3. CHAPTER SELECTOR (Flex 1)
          Expanded(
            flex: 1,
            child: _ChapterSelector(
              selectedChapter: selectedChapter,
              onChanged: onChapterChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// EXTRACTED WIDGETS
// ==============================================================================

class _TranslationSelector extends StatelessWidget {
  final String selectedId;
  final Function(String) onChanged;

  const _TranslationSelector({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Safety check: if the selected ID isn't in the list, fallback to the first one
    final isValidSelection = AvailableBibleTranslations.any((t) => t.id == selectedId);
    final valueToUse = isValidSelection ? selectedId : AvailableBibleTranslations.first.id;

    return DropdownButtonFormField<String>(
      value: valueToUse,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Ver.',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      items: AvailableBibleTranslations.map((t) {
        return DropdownMenuItem(
          value: t.id,
          child: Text(
            t.abbreviation, // Use abbreviation (e.g. "WEB", "B21") to save space
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: (val) => val != null ? onChanged(val) : null,
    );
  }
}

class _BookSelector extends StatelessWidget {
  final int selectedBookId;
  final AsyncValue<List<dynamic>> booksAsync;
  final Function(int) onChanged;

  const _BookSelector({
    required this.selectedBookId,
    required this.booksAsync,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return booksAsync.when(
      loading: () => const SizedBox(
        height: 48, 
        child: Center(child: LinearProgressIndicator())
      ),
      error: (_, __) => const SizedBox(), 
      data: (books) {
        // Safety: Ensure selectedBookId actually exists in the loaded list
        final isValid = books.any((b) => b.id == selectedBookId);
        final safeValue = isValid ? selectedBookId : (books.isNotEmpty ? books.first.id : null);

        if (safeValue == null) return const SizedBox();

        return DropdownButtonFormField<int>(
          value: safeValue,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Book',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          items: books.map<DropdownMenuItem<int>>((book) {
            return DropdownMenuItem(
              value: book.id,
              child: Text(
                book.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) => val != null ? onChanged(val) : null,
        );
      },
    );
  }
}

class _ChapterSelector extends StatelessWidget {
  final int selectedChapter;
  final Function(int) onChanged;

  const _ChapterSelector({
    required this.selectedChapter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedChapter,
      isExpanded: true,
      menuMaxHeight: 300, // Limits height so it doesn't cover the whole screen
      decoration: const InputDecoration(
        labelText: 'Ch.',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
      // Generates 150 chapters. 
      // Note: Ideally this should limit based on the selected book's max chapters.
      items: List.generate(150, (i) => i + 1).map((c) {
        return DropdownMenuItem(
          value: c,
          child: Center(
            child: Text(
              "$c", 
              style: const TextStyle(fontSize: 13)
            )
          ),
        );
      }).toList(),
      onChanged: (val) => val != null ? onChanged(val) : null,
    );
  }
}