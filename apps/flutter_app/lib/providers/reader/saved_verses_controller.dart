import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/saved_verse.dart';
import 'package:flutter_app/data/repositories/saved_verses_repository.dart';

/// Provider to access the SavedVersesController from the UI
final savedVersesControllerProvider = 
    AsyncNotifierProvider<SavedVersesController, List<SavedVerse>>(() {
  return SavedVersesController();
});

class SavedVersesController extends AsyncNotifier<List<SavedVerse>> {
  late final SavedVersesRepository _repository;

  @override
  Future<List<SavedVerse>> build() async {
    _repository = await ref.watch(savedVersesRepositoryProvider.future);
    return _repository.getSavedVerses();
  }

  /// Adds multiple verses to the backend and updates the local state immediately
  Future<void> addVerses(List<VerseCreationPayload> versesToSave) async {
    // We keep the current state value while loading to prevent UI flicker
    final previousState = state.value;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final newVerses = await _repository.saveVerses(versesToSave);

      return [...?previousState, ...newVerses];
    });
  }

  /// Removes a verse by ID and updates the UI locally
  Future<void> deleteVerse(String verseId) async {
    final previousState = state.value;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _repository.deleteVerse(verseId);
      
      // Filter out the deleted verse from the local list
      return previousState?.where((v) => v.id != verseId).toList() ?? [];
    });
  }
}