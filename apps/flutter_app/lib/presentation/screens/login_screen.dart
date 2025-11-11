import 'package:flutter/material.dart';
import '/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.login_screenTitle)),
      body: const Center(
        child: SignInButton(),
      ),
    );
  }
}