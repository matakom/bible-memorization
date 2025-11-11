import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

class AddFriendButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddFriendButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.person_add),
      label: Text(context.l10n.social_addFriend),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}