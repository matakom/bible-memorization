import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/current_translation_provider.dart';
import '../../providers/reader_provider.dart'; // For controller
import '../design_system/app_dimens.dart';
import '../widgets/reader/bible_nav_header.dart';
import '../widgets/reader/verse_item.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  // State is owned here
  int _selectedBookId = 1; // Default: Genesis
  int _selectedChapter = 1;

  @override
  Widget build(BuildContext context) {
    // 1. Watch Data
    final currentTranslation = ref.watch(currentTranslationProvider);
    final booksAsync = ref.watch(bibleBooksProvider);
    
    // 2. Fetch Verses (This auto-updates when Book/Chapter/Translation changes)
    final versesAsync = ref.watch(bibleChapterProvider(
      (bookId: _selectedBookId, chapter: _selectedChapter)
    ));

    // 3. Calculate Dynamic Max Chapters
    final int maxChapters = K_BIBLE_CHAPTER_COUNTS[_selectedBookId] ?? 150;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scripture Reader'),
        // We use a slightly taller app bar bottom to accommodate the controls comfortably
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: BibleNavHeader(
            // Translation Control
            selectedTranslationId: currentTranslation,
            onTranslationChanged: (newId) {
              ref.read(currentTranslationProvider.notifier).state = newId;
            },
            
            // Book Control
            selectedBookId: _selectedBookId,
            booksAsync: booksAsync,
            onBookChanged: (newBookId) {
              setState(() {
                _selectedBookId = newBookId;
                // RESET chapter to 1 when changing books to avoid "Chapter 50 of Jude" error
                _selectedChapter = 1; 
              });
            },
            
            // Chapter Control
            selectedChapter: _selectedChapter,
            maxChapters: maxChapters, // <--- Dynamic max
            onChapterChanged: (newChapter) {
              setState(() => _selectedChapter = newChapter);
            },
          ),
        ),
      ),
      body: versesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading text: $err')),
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacings.l),
                child: Text('Select a translation, book, and chapter to begin.'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacings.m),
            itemCount: verses.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacings.s),
            itemBuilder: (context, index) {
              final verse = verses[index];
              return VerseItem(
                state: verse,
                onTap: () {
                  ref.read(readerControllerProvider).toggleVerse(verse);
                },
              );
            },
          );
        },
      ),
    );
  }
}