import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/reader/reader_settings_controller.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';

import '../../../utils/debugger.dart';

/// Modal bottom sheet allowing users to customize text appearance in the Bible reader.
class AppearanceBottomSheet extends ConsumerWidget {
  const AppearanceBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(readerSettingsProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      height: 250,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) { 
          Debugger.log('Error: $err');
          return Center(child: Text(context.l10n.something_went_wrong));
        },
        data: (settings) {
          final controller = ref.read(readerSettingsProvider.notifier);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.reader_appearanceTitle,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  const Icon(Icons.text_fields, size: 16),
                  Expanded(
                    child: Slider(
                      value: settings.fontSizeScale,
                      min: 0.8,
                      max: 1.8,
                      divisions: 5,
                      label: '${(settings.fontSizeScale * 100).round()}%',
                      onChanged: (val) => controller.setFontSize(val),
                    ),
                  ),
                  const Icon(Icons.text_fields, size: 24),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _OptionButton(
                    label: settings.fontFamily == 'Sans' 
                        ? context.l10n.reader_appearanceSerif 
                        : context.l10n.reader_appearanceSansSerif,
                    icon: Icons.font_download_outlined,
                    isSelected: settings.fontFamily == 'Serif',
                    onTap: () => controller.toggleFontFamily(),
                  ),
                  _OptionButton(
                    label: context.l10n.reader_appearanceSpacing,
                    icon: Icons.format_line_spacing,
                    isSelected: settings.lineHeight > 1.8,
                    onTap: () => controller.setLineHeight(settings.lineHeight > 1.8 ? 1.6 : 2.2),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}