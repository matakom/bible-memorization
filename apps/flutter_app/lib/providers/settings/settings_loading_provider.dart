import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the loading state of settings and account-related asynchronous operations.
class SettingsLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

final settingsLoadingProvider =
    NotifierProvider<SettingsLoadingNotifier, bool>(() {
  return SettingsLoadingNotifier();
});