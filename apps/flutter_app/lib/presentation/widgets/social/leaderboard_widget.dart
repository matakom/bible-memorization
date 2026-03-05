import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';

class LeaderboardEntry {
  final String id;
  final String name;
  final int score;
  final bool isMe;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.score,
    required this.isMe,
  });
}

final leaderboardProvider = FutureProvider.autoDispose<List<LeaderboardEntry>>((ref) async {
  final currentUser = ref.watch(userDataProvider).value;
  final myStats = await ref.watch(myStatsProvider.future);
  final friendships = ref.watch(friendshipsProvider).value ?? [];

  if (currentUser == null) return [];

  // 1. Add yourself
  List<LeaderboardEntry> entries = [
    LeaderboardEntry(
      id: currentUser.id,
      name: "${currentUser.firstName} ${currentUser.lastName} (You)",
      score: myStats.score,
      isMe: true,
    )
  ];

  // 2. Fetch all accepted friends' stats
  final acceptedFriends = friendships.where((f) => f.status == 'accepted').toList();
  final friendFutures = acceptedFriends.map((f) async {
    final otherId = f.userId == currentUser.id ? f.friendId : f.userId;
    try {
      final repo = await ref.read(statsRepositoryProvider.future);
      final stats = await repo.getFriendStats(otherId);
      
      return LeaderboardEntry(
        id: otherId,
        name: "${f.friendFirstName} ${f.friendLastName}",
        score: stats.score,
        isMe: false,
      );
    } catch (e) {
      return LeaderboardEntry(
        id: otherId,
        name: "${f.friendFirstName} ${f.friendLastName}",
        score: 0,
        isMe: false,
      );
    }
  });

  final friendEntries = await Future.wait(friendFutures);
  entries.addAll(friendEntries);

  // 3. Sort by highest score
  entries.sort((a, b) => b.score.compareTo(a.score));
  return entries;
});

class LeaderboardWidget extends ConsumerWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
          child: Text(
            "LEADERBOARD",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        leaderboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Could not load leaderboard: $err"),
          ),
          data: (entries) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final rank = index + 1;

                  Widget? leadingWidget;
                  if (rank == 1) {
                    leadingWidget = const Icon(Icons.workspace_premium, color: Colors.amber, size: 32);
                  } else if (rank == 2) {
                    leadingWidget = const Icon(Icons.workspace_premium, color: Colors.grey, size: 32);
                  } else if (rank == 3) {
                    leadingWidget = const Icon(Icons.workspace_premium, color: Colors.deepOrange, size: 32);
                  } else {
                    leadingWidget = SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          "#$rank",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                        ),
                      ),
                    );
                  }

                  return ListTile(
                    leading: leadingWidget,
                    title: Text(
                      entry.name,
                      style: TextStyle(
                        fontWeight: entry.isMe ? FontWeight.bold : FontWeight.normal,
                        color: entry.isMe ? theme.colorScheme.primary : null,
                      ),
                    ),
                    trailing: Text(
                      "${entry.score} pts",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    tileColor: entry.isMe ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2) : null,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}