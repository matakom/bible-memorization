import 'package:flutter/material.dart';
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
      items: const [
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark'),
        ),
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System Default'),
        ),
      ],
    );
  }
}