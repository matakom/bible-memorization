import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_button.dart';
import 'package:flutter_app/presentation/widgets/social/add_friend_modal_content.dart';
import 'package:flutter_app/presentation/widgets/social/friends_list_widget.dart';
import 'package:flutter_app/presentation/widgets/social/user_code.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/core/dio_provider.dart';
import '../../utils/network_exceptions.dart';

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
        error: (err, stack) {
          // --- HANDLE EXPLICIT NETWORK/SERVER ERRORS FOR USER FETCH ---
          if (err is OfflineException) {
            return _buildPlaceholder(
              context,
              Icons.cloud_off,
              context.l10n.social_unavailableOfflineTitle,
              context.l10n.social_unavailableOfflineDescription,
            );
          } else if (err is ServerDownException) {
            return _buildPlaceholder(
              context,
              Icons.dns_outlined,
              context.l10n.social_serverUnreachableTitle,
              context.l10n.social_serverUnreachableDescription,
            );
          }
          return Center(
            child: Text(context.l10n.social_errorLoadingUser(err.toString())),
          );
        },
        data: (user) {
          // 1. --- GUEST VIEW (Not Logged In) ---
          // Guests don't need the server just to see the login button.
          if (user == null) {
            return _buildGuestView(context);
          }

          // 2. --- OFFLINE FALLBACK VIEW ---
          if (user.friendCode.isEmpty) {
            return _buildPlaceholder(
              context,
              Icons.cloud_off,
              context.l10n.social_unavailableOfflineTitle,
              context.l10n.social_unavailableServerOfflineDescription,
            );
          }

          // 3. --- LIVE SERVER CHECK ---
          // Guard the cached SQLite data behind a live server ping.
          final serverHealth = ref.watch(serverHealthCheckProvider);

          return serverHealth.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              // Server is down or phone is offline -> Block access to the page!
              if (err is ServerDownException) {
                return _buildPlaceholder(
                  context,
                  Icons.dns_outlined,
                  context.l10n.social_serverUnreachableTitle,
                  context.l10n.social_serverUnreachableDescription,
                );
              }
              return _buildPlaceholder(
                context,
                Icons.cloud_off,
                context.l10n.social_unavailableOfflineTitle,
                context.l10n.social_unavailableServerOfflineDescription,
              );
            },
            data: (_) {
              // 4. --- AUTHENTICATED VIEW (Logged In, Online, Server Alive) ---
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
                error: (err, stack) {
                  return Center(
                    child: Text(
                      context.l10n.social_errorLoadingFriendships(
                        err.toString(),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
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
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_alt_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.social_guestTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.social_guestDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            const SizedBox(
              width: double.infinity,
              height: 50,
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
final serverHealthCheckProvider = FutureProvider.autoDispose<void>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  final cancelToken = CancelToken();

  // 1. Create the Timer Future
  final timerFuture = Future.delayed(const Duration(seconds: 5), () {
    cancelToken.cancel("Authoritative UI Timeout");
    throw ServerDownException();
  });

  // 2. Create the Request Future
  final requestFuture = dio.get('/user', cancelToken: cancelToken);

  try {
    // 3. Race them using Future.wait with a custom "first winner" logic
    await Future.wait([
      Future.any([timerFuture, requestFuture])
    ]);
  } on DioException catch (e) {
    // This catches the cancellation from our 5s timer
    if (CancelToken.isCancel(e) || (e.response?.statusCode != null && e.response!.statusCode! >= 500)) {
      throw ServerDownException();
    }
    throw OfflineException();
  } on ServerDownException {
    rethrow; // Timer won
  } catch (e) {
    throw OfflineException();
  } finally {
    // 4. CRITICAL: Cleanup any hanging request if we aren't already cancelled
    if (!cancelToken.isCancelled) cancelToken.cancel();
  }
});