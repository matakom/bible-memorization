import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/settings/delete_account_button.dart';
import 'package:flutter_app/presentation/widgets/settings/get_token_button.dart';
import 'package:flutter_app/presentation/widgets/settings/locale_select.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_out_button.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';
import 'package:flutter_app/presentation/widgets/settings/theme_select.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_app/providers/user_provider.dart';

import '../../utils/debugger.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user state to conditionally render the Delete Account button
    final currentUser = ref.watch(userDataProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings_screenTitle)),
      // Using ListView so it's scrollable if the debug tools get too long
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dynamic Account Header
          const _AccountSection(),

          const SizedBox(height: 16),
          const Divider(),

          Column(children: [LocaleSelect(), ThemeSelect()]),

          // Only show Delete Account if they are actually logged in
          if (currentUser != null) ...[
            const SizedBox(height: 8),
            const DeleteAccountButton(),
          ],

          const SizedBox(height: 16),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              context.l10n.settings_debugTools,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          GetTokenButton(),
          ElevatedButton(
            child: Text(context.l10n.settings_debugDb),
            onPressed: () {
              final database = ref.read(db.databaseProvider);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DriftDbViewer(database),
                ),
              );
            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.timer),
            label: Text(context.l10n.settings_testNotification),
            onPressed: () async {
              await NotificationService.scheduleTestNotification();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.settings_notificationScheduled),
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(context.l10n.settings_forceSync),
            subtitle: Text(context.l10n.settings_forceSyncDescription),
            onTap: () async {
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.settings_syncing),
                    duration: const Duration(seconds: 1),
                  ),
                );

                final syncService = await ref.read(syncServiceProvider.future);
                // Capture the result
                final isFullSuccess = await syncService.runSync();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFullSuccess
                            ? context.l10n.settings_syncSuccess
                            : context.l10n.settings_syncPartialSuccess,
                      ),
                      backgroundColor: isFullSuccess ? null : Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                Debugger.log("MANUAL SYNC ERROR: $e");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.settings_syncFailed),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// --- DYNAMIC ACCOUNT CARD WIDGET ---
class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    final theme = Theme.of(context);

    return userDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.l10n.settings_errorLoadingProfile(err.toString()),
          ),
        ),
      ),
      data: (currentUser) {
        // --- GUEST CARD ---
        if (currentUser == null) {
          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.settings_guestUser,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.l10n.settings_guestProgressSavedLocally,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SignInButton(), // Your custom button
                ],
              ),
            ),
          );
        }

        // --- LOGGED IN CARD ---
        return Card(
          elevation: 0,
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    currentUser.firstName.isNotEmpty
                        ? currentUser.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentUser.firstName} ${currentUser.lastName}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SignOutButton(), // Your custom button
              ],
            ),
          ),
        );
      },
    );
  }
}
