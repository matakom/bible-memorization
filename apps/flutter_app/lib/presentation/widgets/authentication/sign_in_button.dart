import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_controller.dart';
import 'package:flutter_app/providers/settings/settings_loading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/l10n_extension.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(settingsLoadingProvider);

    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(context.l10n.login_signInButton),
            onPressed: () async {
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .signInWithGoogle();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${context.l10n.login_errorOnSignIn} $e'),
                    ),
                  );
                }
              }
            },
          );
  }
}
