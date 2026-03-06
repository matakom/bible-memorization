import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Card widget that displays the current user's unique 6-character friend code for sharing.
class UserCode extends ConsumerWidget {
  const UserCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? code = ref.watch(userDataProvider).value?.friendCode;

    if (code == null) return const Center(child: CircularProgressIndicator());

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.social_yourCode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SelectableText('${code.substring(0, 3)}-${code.substring(3, 6)}', style: const TextStyle(fontSize: 24, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}