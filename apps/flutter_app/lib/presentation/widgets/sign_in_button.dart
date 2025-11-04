import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/l10n_extension.dart';

class SignInButton extends ConsumerStatefulWidget {
  const SignInButton({super.key});

  @override
  ConsumerState<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SignInButton> {
  bool _isLoading = false;

  Future<void> _signIn() async {
    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.login_errorOnSignIn} $e')),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(context.l10n.login_signInButton),
            onPressed: _signIn,
          );
  }
}