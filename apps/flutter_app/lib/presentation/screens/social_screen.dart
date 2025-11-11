import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/add_friend_button.dart';
import 'package:flutter_app/presentation/widgets/add_friend_modal_content.dart';
import 'package:flutter_app/presentation/widgets/user_code.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.social_screenTitle)),
      body: Center(
        child: Column(
          children: [
            UserCode(),
            AddFriendButton(
              onPressed: () {
                _showAddFriendModal(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return AddFriendModalContent();
      },
    );
  }
}
