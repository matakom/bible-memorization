import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/practice_repository.dart';
import 'package:flutter_app/data/repositories/saved_verses_repository.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

/// Button that handles the multi-step process of remote account deletion and local data wiping.
class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.l10n.settings_deleteAccountDialogTitle),
          content: Text(dialogContext.l10n.settings_deleteAccountDialogBody),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(false),
              child: Text(dialogContext.l10n.settings_deleteAccountCancel),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => dialogContext.pop(true),
              child: Text(dialogContext.l10n.settings_deleteAccountConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext loadingContext) => const Center(child: CircularProgressIndicator()),
        );

        final repo = await ref.read(userRepositoryProvider.future);
        await repo.deleteAccountLocally();

        ref.invalidate(userDataProvider);
        ref.invalidate(userRepositoryProvider);
        ref.invalidate(friendshipsProvider);
        ref.invalidate(practiceRepositoryProvider);
        ref.invalidate(savedVersesRepositoryProvider);
        ref.invalidate(statsRepositoryProvider);
        ref.invalidate(syncServiceProvider);

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.settings_deleteAccountSuccess),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/practice');
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();

          final errorString = e.toString().toLowerCase();
          final isNoInternet = errorString.contains("check your internet") ||
              errorString.contains("socketexception") ||
              errorString.contains("network_error");

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(isNoInternet ? context.l10n.settings_deleteAccountOfflineTitle : context.l10n.settings_deleteAccountErrorTitle),
              content: Text(isNoInternet ? context.l10n.settings_deleteAccountOfflineBody : context.l10n.settings_deleteAccountGeneralError),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red,
        elevation: 0,
      ),
      icon: const Icon(Icons.delete_forever),
      label: Text(context.l10n.settings_deleteAccountButton),
      onPressed: () => _showDeleteConfirmation(context, ref),
    );
  }
}