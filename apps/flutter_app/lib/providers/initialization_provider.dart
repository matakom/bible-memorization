import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/core/repository_providers.dart';
import 'package:flutter_app/services/bible_loader.dart';

// This FutureProvider will start executing as soon as it is read/watched.
final bibleBootstrapperProvider = FutureProvider<void>((ref) async {
  // This will open the DB if it isn't open yet
  final db = ref.watch(databaseProvider);
  
  final bootstrapper = BibleLoader(db);
  
  // This runs the check/insert logic. 
  // Since we are inside a FutureProvider, Riverpod handles the async state.
  await bootstrapper.initialize();
});