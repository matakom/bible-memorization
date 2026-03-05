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
        // Show a loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext loadingContext) => const Center(child: CircularProgressIndicator()),
        );

        // Wipe local SQLite and SharedPreferences
        final repo = await ref.read(userRepositoryProvider.future);
        await repo.deleteAccountLocally();

        // Tell Riverpod to refresh the UI with the now-empty database
        ref.invalidate(userDataProvider);
        ref.invalidate(userRepositoryProvider);
        ref.invalidate(friendshipsProvider);
        ref.invalidate(practiceRepositoryProvider);
        ref.invalidate(savedVersesRepositoryProvider);
        ref.invalidate(statsRepositoryProvider);
        ref.invalidate(syncServiceProvider);

        if (context.mounted) {
          // Remove the loading spinner safely
          Navigator.of(context, rootNavigator: true).pop(); 

          // Show a success message
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
          // Remove spinner if there is an error
          Navigator.of(context, rootNavigator: true).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.settings_deleteAccountError(e.toString())),
              backgroundColor: Colors.red,
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