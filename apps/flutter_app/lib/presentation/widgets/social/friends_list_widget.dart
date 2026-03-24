import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/social/leaderboard_widget.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/debugger.dart';
import 'user.dart';
import '../../../data/models/friendship.dart';

/// Organized list of friendships categorized by status (pending, accepted, sent) and includes the leaderboard.
class FriendsListWidget extends ConsumerStatefulWidget {
  final List<Friendship> friendships;
  final String currentUserId;

  const FriendsListWidget({super.key, required this.friendships, required this.currentUserId});

  @override
  ConsumerState<FriendsListWidget> createState() => _FriendsListWidgetState();
}

class _FriendsListWidgetState extends ConsumerState<FriendsListWidget> {
  late List<Friendship> receivedRequests;
  late List<Friendship> acceptedFriends;
  late List<Friendship> sentRequests;

  @override
  void initState() {
    super.initState();
    _sortFriendships();
  }

  @override
  void didUpdateWidget(covariant FriendsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.friendships != oldWidget.friendships) _sortFriendships();
  }

  String _getDirection(Friendship f) => f.userId == widget.currentUserId ? 'sent' : 'received';

  void _sortFriendships() {
    receivedRequests = [];
    acceptedFriends = [];
    sentRequests = [];

    for (var friendship in widget.friendships) {
      final direction = _getDirection(friendship);
      if (friendship.status == 'pending') {
        direction == 'received' ? receivedRequests.add(friendship) : sentRequests.add(friendship);
      } else if (friendship.status == 'accepted') {
        acceptedFriends.add(friendship);
      }
    }
  }

  Future<void> _handleAction(String friendshipId, String action) async {
    try {
      if (action == 'accept') {
        await ref.read(friendshipsProvider.notifier).acceptFriendship(friendshipId);
      } else if (action == 'delete') {
        await ref.read(friendshipsProvider.notifier).deleteFriendship(friendshipId);
      }
    } catch (e) {
      if (mounted) {
        Debugger.log('Error loading stats: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.something_went_wrong)));
      }
    }
  }

  Widget _buildSection(String title, List<Friendship> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
          child: Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, letterSpacing: 0.5)),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text(context.l10n.social_nothingHere, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          )
        else
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              final direction = _getDirection(item);
              final otherPersonId = direction == 'sent' ? item.friendId : item.userId;

              return User(
                firstName: item.friendFirstName, 
                lastName: item.friendLastName,
                status: item.status,
                direction: direction,
                onTap: () => context.go('/social/$otherPersonId/${item.id}'),
                onAccept: () => _handleAction(item.id, 'accept'),
                onDelete: () => _handleAction(item.id, 'delete'),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (receivedRequests.isEmpty && acceptedFriends.isEmpty && sentRequests.isEmpty) {
      return Center(child: Text(context.l10n.social_nothingToSeeHereYet));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          if (receivedRequests.isNotEmpty) _buildSection(context.l10n.social_friendRequest, receivedRequests),
          const LeaderboardWidget(),
          if (acceptedFriends.isNotEmpty) _buildSection(context.l10n.social_friends, acceptedFriends),
          if (sentRequests.isNotEmpty) _buildSection(context.l10n.social_sentRequests, sentRequests),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}