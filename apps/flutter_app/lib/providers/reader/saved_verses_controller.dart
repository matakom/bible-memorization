import 'dart:async';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/repositories/saved_verses_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the state of saved verses, providing methods to add and delete verses while updating the local cache.
class SavedVersesController extends AsyncNotifier<List<SavedVerse>> {
  @override
  Future<List<SavedVerse>> build() async {
    final repository = ref.watch(savedVersesRepositoryProvider);
    return repository.getSavedVerses();
  }

  SavedVersesRepository get _repository => ref.read(savedVersesRepositoryProvider);

  Future<void> addVerses(List<VerseCreationPayload> versesToSave) async {
    final previousState = state.value;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repo = _repository; 
      final newVerses = await repo.saveVerses(versesToSave);
      return [...?previousState, ...newVerses];
    });
  }

  Future<void> deleteVerse(String verseId) async {
    final previousState = state.value;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repo = _repository;
      await repo.deleteVerse(verseId);
      return previousState?.where((v) => v.id != verseId).toList() ?? [];
    });
  }
}

final savedVersesControllerProvider = AsyncNotifierProvider<SavedVersesController, List<SavedVerse>>(SavedVersesController.new);