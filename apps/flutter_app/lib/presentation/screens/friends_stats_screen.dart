import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class FriendStatsScreen extends StatelessWidget {
  final String userId;

  const FriendStatsScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.friendsStats_screenTitle),
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
}