import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/settings/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dropdown selector for toggling between light, dark, and system theme modes.
class ThemeSelect extends ConsumerWidget {
  const ThemeSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeProvider);

    return themeAsync.maybeWhen(
      data: (currentTheme) => DropdownButton<ThemeMode>(
        value: currentTheme,
        isExpanded: true,
        alignment: AlignmentGeometry.center,
        onChanged: (ThemeMode? newTheme) {
          if (newTheme != null) {
            ref.read(themeProvider.notifier).setTheme(newTheme);
          }
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Center(child: Text(context.l10n.settings_themeLight)),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Center(child: Text(context.l10n.settings_themeDark)),
          ),
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Center(child: Text(context.l10n.settings_themeSystem)),
          ),
        ],
      ),
      orElse: () => const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}