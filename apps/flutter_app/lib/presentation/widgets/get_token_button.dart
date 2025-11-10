import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/debugger.dart';
import '/l10n/l10n_extension.dart';

class GetTokenButton extends ConsumerStatefulWidget {
  const GetTokenButton({super.key});

  @override
  ConsumerState<GetTokenButton> createState() => _GetTokenButtonState();
}

class _GetTokenButtonState extends ConsumerState<GetTokenButton> {

  Future<void> _printToken() async {
    final authRepo = ref.read(authRepositoryProvider);
        final String? token = await authRepo.getAuthToken();
        Debugger.log(token?.length.toString() ?? '');
        Debugger.log('$token');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
            icon: const Icon(Icons.token),
            label: Text(context.l10n.settings_token_button),
            onPressed: _printToken,
          );
  }
}