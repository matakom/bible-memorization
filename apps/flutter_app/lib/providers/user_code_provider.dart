import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCodeNotifier extends Notifier<String?> {
  
  @override
  String? build() {
    return null;
  }

  void initialize(String? code) {
    state = code;
  }
}

final userCodeProvider = NotifierProvider<UserCodeNotifier, String?>(() {
  return UserCodeNotifier();
});