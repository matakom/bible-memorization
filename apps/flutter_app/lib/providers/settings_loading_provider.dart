import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  /// Sets the loading state.
  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

/// The provider for the SettingsLoadingNotifier.
final settingsLoadingProvider =
    NotifierProvider<SettingsLoadingNotifier, bool>(() {
  return SettingsLoadingNotifier();
});