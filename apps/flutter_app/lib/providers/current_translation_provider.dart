import 'package:flutter_riverpod/flutter_riverpod.dart';

// The "Notifier" replaces StateProvider for simple mutable state
final currentTranslationProvider = NotifierProvider<TranslationNotifier, String>(() {
  return TranslationNotifier();
});

class TranslationNotifier extends Notifier<String> {
  @override
  String build() {
    return 'B21'; // Default value
  }

  // Method to update the value
  void setTranslation(String newTranslation) {
    state = newTranslation;
  }
}