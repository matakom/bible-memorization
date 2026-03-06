import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Utility class for formatted logging during development.
class Debugger {
  static int numberOfDashes = 20;

  static void log(String text) {
    if (kDebugMode) {
      if(text.length > 700) {
        developer.log(text, name: 'TOKEN');
      } else {
        final String padding = '-' * numberOfDashes;
        print('$padding|$text|$padding');
        developer.log(text);
      }
    }
  }
}