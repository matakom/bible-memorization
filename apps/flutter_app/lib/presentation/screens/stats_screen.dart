import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/presentation/widgets/stats/stats_profile_view.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

/// Screen displaying the current user's learning stats, streaks, and progress.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(myStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.stats_screenTitle)),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(context.l10n.stats_errorLoadingStats(err.toString()))),
        data: (stats) => StatsProfileView(stats: stats),
      ),
    );
  }
}