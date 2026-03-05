import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/settings/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelect extends ConsumerWidget {
  const ThemeSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the AsyncValue
    final themeAsync = ref.watch(themeProvider);

    return themeAsync.maybeWhen(
      // Only show the dropdown once we know the current theme
      data: (currentTheme) => DropdownButton<ThemeMode>(
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
      ),
      // Fallback UI while loading from SharedPreferences
      orElse: () => const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}