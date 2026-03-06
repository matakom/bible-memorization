/* eslint-disable prettier/prettier */
import 'dart:async';
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
import 'package:flutter_app/utils/debugger.dart';

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

      // Clear any previous offline flags on a fresh attempt
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_offline_login', false);

      // 2. Try to reach the server, but DO NOT fail the login if it's down!
      try {
        final userRepo = await ref.read(userRepositoryProvider.future);
        
        // Fetch profile from NestJS
        await userRepo.getUserData(manualToken: token).timeout(
          const Duration(seconds: 5),
        );

        ref.invalidate(userDataProvider);

        // Trigger initial sync in the background
        ref.read(syncServiceProvider.future).then((service) => service.runSync());
      } catch (serverError) {
        // FIX: The server is unreachable or timed out.
        // We are still 'Logged In' via Firebase, so we set the offline flag.
        await prefs.setBool('is_offline_login', true);
        Debugger.log("Login: Server unreachable. User authenticated locally. $serverError");
      }

      state = const AsyncData(null);

    } catch (e, stack) {
      // General failure (Google Play Services issues, no internet at all, etc.)
      Debugger.log("Auth Error: $e");
      
      try {
        await ref.read(authRepositoryProvider).signOut();
      } catch (_) {}

      state = AsyncError(e.toString(), stack);
      // We rethrow so the UI (SignInButton) can show the SnackBar
      rethrow; 
    } finally {
      ref.read(settingsLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> signOut() async {
    ref.read(settingsLoadingProvider.notifier).setLoading(true);
    try {
      // 1. Firebase Sign out
      await ref.read(authRepositoryProvider).signOut();

      // 2. Clear local relational data (SQLite)
      final database = ref.read(db.databaseProvider);
      await database.clearAllData();

      // 3. Clear all preferences (Themes, Language, Sync timestamps)
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 4. Force UI refresh
      _invalidateUserData();
    } catch (e) {
      Debugger.log("Sign out error: $e");
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