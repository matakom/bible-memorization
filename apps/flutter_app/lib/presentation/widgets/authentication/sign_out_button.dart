import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_controller.dart';
import 'package:flutter_app/providers/settings/settings_loading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/l10n_extension.dart';

/// A button that handles the sign-out process with integrated loading state.
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(settingsLoadingProvider);

    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(context.l10n.settings_signOutButton),
            onPressed: () async {
              try {
                await ref.read(authControllerProvider.notifier).signOut();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${context.l10n.settings_errorOnSignOut} $e',
                      ),
                    ),
                  );
                }
              }
            },
          );
  }
}