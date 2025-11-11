import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_button.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_modal_content.dart';
import 'package:flutter_app/presentation/widgets/social/friends_list_widget.dart';
import 'package:flutter_app/presentation/widgets/social/user_code.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFriendships = ref.watch(friendshipsProvider);
    final currentUserId = ref.watch(userDataProvider).value?.id;

    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text('Error: User not logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.social_screenTitle)),
      body: asyncFriendships.when(
        data: (friendships) {
          return Center(
            child: Column(
              children: [
                UserCode(),
                AddFriendButton(
                  onPressed: () {
                    _showAddFriendModal(context);
                  },
                ),
                FriendsListWidget(
                  friendships: friendships,
                  currentUserId: currentUserId,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading friendships: $err',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }

  void _showAddFriendModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return AddFriendModalContent();
      },
    );
  }
}
