import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/current_translation_provider.dart';
// Import where you defined the class and list

import '../../../config/bible_translations.dart'; 

class TranslationSelector extends ConsumerWidget {
  const TranslationSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch current selection
    final currentId = ref.watch(currentTranslationProvider);
    
    // 2. Ensure current selection is valid (fallback to first if not found)
    // This prevents crashes if 'WEB' was stored but now you only have 'b21'
    final validSelection = AvailableBibleTranslations.any((t) => t.id == currentId)
        ? currentId
        : AvailableBibleTranslations.first.id;

    return DropdownButton<String>(
      value: validSelection,
      // 3. Map your constant list to DropdownItems
      items: AvailableBibleTranslations.map((translation) {
        return DropdownMenuItem<String>(
          value: translation.id,
          child: Text(translation.name),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          ref.read(currentTranslationProvider.notifier).state = newValue;
        }
      },
    );
  }
}