import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/presentation/widgets/stats/stats_profile_view.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(myStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading stats: $err')),
        data: (stats) => StatsProfileView(stats: stats),
      ),
    );
  }
}