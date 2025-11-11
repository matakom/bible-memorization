import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/presentation/widgets/settings/get_token_button.dart';
import 'package:flutter_app/presentation/widgets/settings/locale_select.dart';
import 'package:flutter_app/presentation/widgets/authentication/sign_out_button.dart';
import 'package:flutter_app/presentation/widgets/settings/theme_select.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings_screenTitle)),
      body: Center(
        child: Column(
          children: [
            SignOutButton(),
            LocaleSelect(),
            ThemeSelect(),
            GetTokenButton()
          ],
        ),
      ),
    );
  }
}