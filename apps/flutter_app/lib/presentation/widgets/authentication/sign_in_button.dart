import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/l10n_extension.dart';

/// A button that handles Google Sign-In and displays a loading indicator during the authentication process.
class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return isLoading
        ? const SizedBox(
            height: 24, 
            width: 24, 
            child: Center(child: CircularProgressIndicator(strokeWidth: 2))
          )
        : ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(context.l10n.login_signInButton),
            onPressed: () async {
              try {
                await ref.read(authControllerProvider.notifier).signInWithGoogle();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          );
  }
}