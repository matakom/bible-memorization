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

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      // FIX 1: Renamed 'context' to 'dialogContext' here so it matches the buttons
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete All Data'),
          content: const Text(
            'Are you sure you want to wipe all your data? This will permanently remove all your saved verses, statistics, and friendships. You will start completely fresh.',
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(false), // Uses go_router
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => dialogContext.pop(true), // Uses go_router
              child: const Text('Delete'),
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
          // FIX 2: Named this 'loadingContext' to prevent context mix-ups
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
            const SnackBar(
              content: Text('All data deleted. Starting fresh!'),
              backgroundColor: Colors.green,
            ),
          );

          // FIX 3: Reset the go_router shell so you don't get a black screen
          context.go('/practice'); 
        }
      } catch (e) {
        if (context.mounted) {
          // Remove spinner if there is an error
          Navigator.of(context, rootNavigator: true).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting data: $e'),
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
      label: const Text('Delete Account'),
      onPressed: () => _showDeleteConfirmation(context, ref),
    );
  }
}