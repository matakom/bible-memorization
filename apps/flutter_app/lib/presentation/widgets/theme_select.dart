import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelect extends ConsumerWidget {
  const ThemeSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode currentTheme = ref.watch(themeProvider);

    return DropdownButton<ThemeMode>(
      value: currentTheme,
      onChanged: (ThemeMode? newTheme) {
        if (newTheme != null) {
          ref.read(themeProvider.notifier).setTheme(newTheme);
        }
      },
      items: [
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(context.l10n.settings_themeLight),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(context.l10n.settings_themeDark),
        ),
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(context.l10n.settings_themeSystem),
        ),
      ],
    );
  }
}