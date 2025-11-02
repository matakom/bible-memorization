import 'package:flutter/foundation.dart';

class Debugger {
  static int numberOfDashes = 20;

  /// Custom printing method
  static void log(String text) {
    if (kDebugMode) {
      final String padding = '-' * numberOfDashes;
      print('$padding|${text.toUpperCase()}|$padding');
    }
  }
}
