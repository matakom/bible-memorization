import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/config/bible_translations.dart';
import 'package:flutter_app/providers/reader/bible_provider.dart';

/// Popup button widget for switching between different Bible translations.
class BibleTranslationSelector extends ConsumerWidget {
  const BibleTranslationSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVersionAsync = ref.watch(currentBibleTranslationProvider);

    return currentVersionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (currentVersion) {
        return PopupMenuButton<BibleTranslation>(
          initialValue: currentVersion,
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              currentVersion.abbreviation,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          onSelected: (version) {
            ref.read(currentBibleTranslationProvider.notifier).setVersion(version);
          },
          itemBuilder: (context) {
            return availableBibleTranslations.map((version) {
              return PopupMenuItem(
                value: version,
                child: Row(
                  children: [
                    Text(version.abbreviation, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(version.name)),
                    if (version.id == currentVersion.id)
                      Icon(Icons.check, color: Theme.of(context).primaryColor, size: 18),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}