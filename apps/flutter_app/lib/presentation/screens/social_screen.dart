import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_button.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_modal_content.dart';
import 'package:flutter_app/presentation/widgets/social/friends_list_widget.dart';
import 'package:flutter_app/presentation/widgets/social/user_code.dart';
// Note: Ensure this import path matches where you put your SignInButton!
import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFriendships = ref.watch(friendshipsProvider);
    final asyncUser = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.social_screenTitle)),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(context.l10n.social_errorLoadingUser(err.toString()))),
        data: (user) {
          
          // --- GUEST VIEW (Not Logged In) ---
          if (user == null) {
            return _buildGuestView(context);
          }
          
          // --- OFFLINE CHECK ---
          if (user.friendCode == 'OFFLINE') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.social_unavailableOfflineTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.social_unavailableOfflineDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // --- AUTHENTICATED VIEW (Logged In & Online) ---
          final currentUserId = user.id;

          return asyncFriendships.when(
            data: (friendships) {
              return Column(
                children: [
                  const UserCode(),
                  AddFriendButton(
                    onPressed: () => _showAddFriendModal(context),
                  ),
                  Expanded(
                    child: FriendsListWidget(
                      friendships: friendships,
                      currentUserId: currentUserId,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                context.l10n.social_errorLoadingFriendships(err.toString()),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }

  // Beautiful Call-to-Action for users who haven't logged in yet
  Widget _buildGuestView(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people_alt_outlined, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.social_guestTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.social_guestDescription,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Your Custom Sign In Button!
            const SizedBox(
              width: double.infinity,
              height: 50, // Making it slightly taller for better tap target
              child: SignInButton(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return const AddFriendModalContent();
      },
    );
  }
}