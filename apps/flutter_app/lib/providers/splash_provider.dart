import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashDelayProvider = FutureProvider<void>((ref) {
  return Future.delayed(const Duration(milliseconds: 500));
});