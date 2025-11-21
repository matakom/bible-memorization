import 'package:flutter/material.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class FriendStatsScreen extends ConsumerWidget {
  final String userId;
  final String friendshipId;

  const FriendStatsScreen({
    super.key,
    required this.userId,
    required this.friendshipId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.friendsStats_screenTitle),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_remove,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => _onDeletePressed(context, ref),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bar_chart, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                context.l10n.common_comingSoon,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.friendsStats_future,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.social_unfriendTitle),
        content: Text(context.l10n.social_unfriendBody),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(context.l10n.social_cancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.social_remove),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(friendshipsProvider.notifier)
          .deleteFriendship(friendshipId);

      if (context.mounted) context.pop();
    }
  }
}