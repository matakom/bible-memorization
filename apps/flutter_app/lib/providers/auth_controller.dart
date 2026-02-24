import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_app/data/repositories/practice_repository.dart';
import 'package:flutter_app/data/repositories/saved_verses_repository.dart';
import 'package:flutter_app/data/repositories/stats_repository.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/settings/settings_loading_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;

class AuthController extends AsyncNotifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      // 1. Authenticate with Google/Firebase
      final token = await ref.read(authRepositoryProvider).signInWithGoogle();

      if (token == null) {
        state = const AsyncData(null);
        return;
      }

      // 2. Try to reach the server, but DO NOT fail the login if it's down!
      try {
        final userRepo = await ref.read(userRepositoryProvider.future);
        
        await userRepo.getUserData(manualToken: token).timeout(
          const Duration(seconds: 5),
        );

        ref.read(syncServiceProvider.future).then((service) => service.runSync());
      } catch (serverError) {
        // SERVER IS DOWN: We catch this here so it doesn't trigger the rollback.
        // We are still successfully logged in to Firebase locally!
        print("Offline Login: Server unreachable. Will sync later.");
      }

      state = const AsyncData(null);

    } catch (e, stack) {
      // THIS catch block only runs if Google/Firebase login actually fails.
      try {
        await ref.read(authRepositoryProvider).signOut();
      } catch (_) {}

      state = AsyncError(e.toString(), stack);
      throw Exception("Authentication failed. Please check your internet connection.");
    } finally {
      ref.read(settingsLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> signOut() async {
    ref.read(settingsLoadingProvider.notifier).setLoading(true);
    try {
      await ref.read(authRepositoryProvider).signOut();

      final database = ref.read(db.databaseProvider);
      await database.clearAllData();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _invalidateUserData();
    } catch (e) {
      rethrow;
    } finally {
      ref.read(settingsLoadingProvider.notifier).setLoading(false);
    }
  }

  void _invalidateUserData() {
    ref.invalidate(userDataProvider);
    ref.invalidate(userRepositoryProvider);
    ref.invalidate(friendshipsProvider);
    ref.invalidate(practiceRepositoryProvider);
    ref.invalidate(savedVersesRepositoryProvider);
    ref.invalidate(statsRepositoryProvider);
    ref.invalidate(syncServiceProvider);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});