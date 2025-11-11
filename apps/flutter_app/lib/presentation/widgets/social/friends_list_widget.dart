import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'user.dart';
import '../../../data/models/friendship_data.dart';

class FriendsListWidget extends ConsumerStatefulWidget {
  final List<FriendshipData> friendships;
  final int currentUserId;

  const FriendsListWidget({
    super.key,
    required this.friendships,
    required this.currentUserId,
  });

  @override
  ConsumerState<FriendsListWidget> createState() => _FriendsListWidgetState();
}

class _FriendsListWidgetState extends ConsumerState<FriendsListWidget> {
  late List<FriendshipData> receivedRequests;
  late List<FriendshipData> acceptedFriends;
  late List<FriendshipData> sentRequests;
  late List<FriendshipData> rejectedByThem;
  late List<FriendshipData> rejectedByMe;

  @override
  void initState() {
    super.initState();
    _sortFriendships();
  }

  // Re-sort if the incoming data changes
  @override
  void didUpdateWidget(covariant FriendsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.friendships != oldWidget.friendships) {
      _sortFriendships();
    }
  }

  void _sortFriendships() {
    receivedRequests = [];
    acceptedFriends = [];
    sentRequests = [];
    rejectedByThem = [];
    rejectedByMe = [];

    for (var friendship in widget.friendships) {
      if (friendship.status == 'pending' &&
          friendship.direction == 'received') {
        receivedRequests.add(friendship);
      } else if (friendship.status == 'accepted') {
        acceptedFriends.add(friendship);
      } else if (friendship.status == 'pending' &&
          friendship.direction == 'sent') {
        sentRequests.add(friendship);
      } else if (friendship.status == 'rejected' &&
          friendship.direction == 'received') {
        rejectedByMe.add(friendship);
      } else if (friendship.status == 'rejected' &&
          friendship.direction == 'sent') {
        rejectedByThem.add(friendship);
      }
    }
  }

  Future<void> _handleAction(int friendshipId, String action) async {
    try {
      if (action == 'accept') {
        await ref.read(friendshipsProvider.notifier).acceptFriend(friendshipId);
      } else if (action == 'reject') {
        await ref.read(friendshipsProvider.notifier).rejectFriend(friendshipId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // Helper function to build a list section
  Widget _buildSection(String title, List<FriendshipData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              context.l10n.social_nothingHere,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];

              final FriendUser friendUser;
              if (item.direction == 'sent') {
                friendUser = item.friend;
              } else {
                friendUser = item.user;
              }

              return User(
                firstName: friendUser.firstName,
                lastName: friendUser.lastName,
                status: item.status,
                direction: item.direction,
                onTap: () {
                  context.go('/social/${friendUser.id}');
                },
                onAccept: () => _handleAction(item.id, 'accept'),
                onReject: () => _handleAction(item.id, 'reject'),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (receivedRequests.isEmpty
        && acceptedFriends.isEmpty
        && sentRequests.isEmpty
        && rejectedByMe.isEmpty
        && rejectedByThem.isEmpty) {
      return Center(child: Text(context.l10n.social_nothingToSeeHereYet));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          if (receivedRequests.isNotEmpty)
            _buildSection(context.l10n.social_friendRequest, receivedRequests),

          if (acceptedFriends.isNotEmpty)
            _buildSection(context.l10n.social_friends, acceptedFriends),

          if (sentRequests.isNotEmpty)
            _buildSection(context.l10n.social_sentRequests, sentRequests),

          if (rejectedByMe.isNotEmpty)
            _buildSection(context.l10n.social_rejectedByMe, rejectedByMe),

          if (rejectedByThem.isNotEmpty)
            _buildSection(context.l10n.social_rejectedByThem, rejectedByThem),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
