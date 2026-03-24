import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_button.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_modal_content.dart';
import 'package:flutter_app/presentation/widgets/social/friends_list_widget.dart';
import 'package:flutter_app/presentation/widgets/social/user_code.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';
import 'package:flutter_app/providers/core/connection_provider.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(connectionProvider.notifier).checkConnection(isSilent: true);
    });
    
    final asyncUser = ref.watch(userDataProvider);
    final status = ref.watch(connectionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.social_screenTitle)),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("User Error: $err")),
        data: (user) {
          if (user == null) return _buildGuestView(context);
          if (user.friendCode.isEmpty) return _buildPlaceholder(
            context, Icons.cloud_off, context.l10n.social_unavailableOfflineTitle, 
            context.l10n.social_unavailableServerOfflineDescription
          );

          switch (status) {
            case ConnectionStatus.unknown:
              return const Center(child: CircularProgressIndicator());
            
            case ConnectionStatus.serverDown:
              return _buildErrorState(
                context, ref, Icons.dns_outlined, 
                context.l10n.social_serverUnreachableTitle,
                context.l10n.social_serverUnreachableDescription,
              );

            case ConnectionStatus.offline:
              return _buildErrorState(
                context, ref, Icons.cloud_off, 
                context.l10n.social_unavailableOfflineTitle,
                context.l10n.social_unavailableOfflineDescription,
              );

            case ConnectionStatus.online:
              return _buildSocialContent(context, ref, user.id);
          }
        },
      ),
    );
  }

  Widget _buildSocialContent(BuildContext context, WidgetRef ref, String currentUserId) {
    final asyncFriendships = ref.watch(friendshipsProvider);

    return asyncFriendships.when(
      data: (friendships) => Column(
        children: [
          const UserCode(),
          AddFriendButton(onPressed: () => _showAddFriendModal(context)),
          Expanded(
            child: FriendsListWidget(
              friendships: friendships,
              currentUserId: currentUserId,
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Social Error: $err")),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, IconData icon, String title, String desc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPlaceholder(context, icon, title, desc),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(connectionProvider.notifier).retry(),
            icon: const Icon(Icons.refresh),
            label: const Text("Retry Connection"),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, IconData icon, String title, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

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
                color: theme.colorScheme.primaryContainer.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people_alt_outlined, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text(context.l10n.social_guestTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(context.l10n.social_guestDescription, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            const SizedBox(width: double.infinity, height: 50, child: SignInButton()),
          ],
        ),
      ),
    );
  }

  void _showAddFriendModal(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const AddFriendModalContent());
  }
}