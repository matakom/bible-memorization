import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/reader/saved_verses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/models/practice_feedback.dart'; // Import for GameType
import 'package:flutter_app/providers/practice/practice_session_controller.dart';
import 'package:go_router/go_router.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesState = ref.watch(savedVersesControllerProvider);
    ref.read(myStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.practice_title)),
      body: versesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text(context.l10n.practice_error(err.toString()))),
        data: (allVerses) {
          if (allVerses.isEmpty) {
            return _EmptyLibraryView();
          }
          final now = DateTime.now();
          final dueVerses = allVerses.where((v) {
            final reviewDate = DateUtils.dateOnly(v.nextReviewDate);
            final today = DateUtils.dateOnly(now);
            return !reviewDate.isAfter(today);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DailyStatusCard(
                  dueCount: dueVerses.length,
                  totalCount: allVerses.length,
                  onStart: () {
                    if (dueVerses.isNotEmpty) {
                      _launchPracticeSession(context, ref, dueVerses);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.practice_completedForToday,
                          ),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 32),
                Text(
                  context.l10n.practice_modes,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85, // Adjusted to fit text better
                  children: [
                    _GameCard(
                      title: context.l10n.game_title_flashcards,
                      description: context.l10n.game_desc_flashcards,
                      icon: Icons.style,
                      color: Colors.blue,
                      onTap: () => _launchPracticeSession(
                        context,
                        ref,
                        allVerses,
                        forcedType: GameType.flashcard,
                      ),
                    ),
                    _GameCard(
                      title: context.l10n.game_title_typing,
                      description: context.l10n.game_desc_typing,
                      icon: Icons.keyboard_alt_outlined,
                      color: Colors.orange,
                      onTap: () => _launchPracticeSession(
                        context,
                        ref,
                        allVerses,
                        forcedType: GameType.firstLetterTyping,
                      ),
                    ),
                    _GameCard(
                      title: context.l10n.game_title_builder,
                      description: context.l10n.game_desc_builder,
                      icon: Icons.extension_outlined,
                      color: Colors.purple,
                      onTap: () => _launchPracticeSession(
                        context,
                        ref,
                        allVerses,
                        forcedType: GameType.verseBuilder,
                      ),
                    ),
                    _GameCard(
                      title: context.l10n.game_title_reference,
                      description: context.l10n.game_desc_reference,
                      icon: Icons.menu_book_outlined,
                      color: Colors.green,
                      onTap: () => _launchPracticeSession(
                        context,
                        ref,
                        allVerses,
                        forcedType: GameType.referenceMatch,
                      ),
                    ),
                    _GameCard(
                      title: context.l10n.game_title_choice,
                      description: context.l10n.game_desc_choice,
                      icon: Icons.checklist_rtl_outlined,
                      color: Colors.teal,
                      onTap: () => _launchPracticeSession(
                        context,
                        ref,
                        allVerses,
                        forcedType: GameType.wordChoice,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _launchPracticeSession(
    BuildContext context,
    WidgetRef ref,
    List<SavedVerse> verses, {
    GameType? forcedType,
  }) {
    if (verses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.practice_noVerses)));
      return;
    }

    // Pass the forcedType to the controller
    ref
        .read(practiceSessionProvider.notifier)
        .startSession(verses, forcedGameType: forcedType);

    context.push('/practice_shell');
  }
}

// --- WIDGETS ---
class _DailyStatusCard extends StatelessWidget {
  final int dueCount;
  final int totalCount;
  final VoidCallback onStart;

  const _DailyStatusCard({
    required this.dueCount,
    required this.totalCount,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAllDone = dueCount == 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAllDone
              ? [Colors.green.shade400, Colors.green.shade700]
              : [theme.colorScheme.primary, theme.colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isAllDone ? Colors.green : theme.colorScheme.primary)
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAllDone
                ? context.l10n.practice_completedForToday
                : context.l10n.practice_readeToReview,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAllDone
                ? context.l10n.practice_allVersesReviewed(totalCount)
                : context.l10n.practice_versesScheduled(dueCount),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isAllDone
                    ? Colors.green.shade700
                    : theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(isAllDone ? Icons.check : Icons.play_arrow_rounded),
              label: Text(
                isAllDone
                    ? context.l10n.practice_practiceAnyway
                    : context.l10n.practice_startSession,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _EmptyLibraryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined, 
              size: 80, 
              color: theme.colorScheme.primary.withValues(alpha: 0.5)
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.practice_emptyLibraryTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.practice_emptyLibraryBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/reader'),
              child: Text(context.l10n.practice_emptyLibraryAction),
            ),
          ],
        ),
      ),
    );
  }
}