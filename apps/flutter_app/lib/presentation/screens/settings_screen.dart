import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/settings/delete_account_button.dart';
import 'package:flutter_app/presentation/widgets/settings/get_token_button.dart';
import 'package:flutter_app/presentation/widgets/settings/locale_select.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_out_button.dart';
import 'package:flutter_app/presentation/widgets/settings/theme_select.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/services/sync_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings_screenTitle)),
      body: Center(
        child: Column(
          children: [
            SignOutButton(),
            LocaleSelect(),
            ThemeSelect(),
            DeleteAccountButton(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Debug Tools",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            GetTokenButton(),
            ElevatedButton(
              child: const Text("Debug DB"),
              onPressed: () {
                final database = ref.read(db.databaseProvider);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DriftDbViewer(database),
                  ),
                );
              },
            ),
            // Inside your Settings Screen widget

            ElevatedButton.icon(
              icon: const Icon(Icons.timer),
              label: const Text('Test 10s Notification'),
              onPressed: () async {
                await NotificationService.scheduleTestNotification();
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification scheduled for 10 seconds from now!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text("Force Sync Now"),
              subtitle: const Text("Push/Pull data manually"),
              onTap: () async {
                try {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Syncing...")));

                  final syncService = await ref.read(
                    syncServiceProvider.future,
                  );
                  await syncService.runSync();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sync Success!")),
                    );
                  }
                } catch (e) {
                  print("MANUAL SYNC ERROR: $e");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}