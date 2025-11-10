import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Debugger {
  static int numberOfDashes = 20;

  /// Custom printing method
  static void log(String text) {
    if (kDebugMode) {
      final String padding = '-' * numberOfDashes;
      debugPrint('$padding|$text|$padding');
      if(text.length == 1196){
        developer.log(text, name: 'TOKEN');
      }
      else{
        developer.log(text);
      }
    }
  }
}
