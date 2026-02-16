import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/repository_providers.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  /// Triggers the Google Sign-In flow
  Future<void> loginWithGoogle() async {
    final authRepo = _ref.read(authRepositoryProvider);
    
    try {
      // Calls your repository method (logic provided below)
      final token = await authRepo.signInWithGoogle();
      
      if (token != null) {
        // TODO: Trigger Sync Service here to pull user data immediately
        // For now, the stream in auth_provider.dart will pick it up once it hits DB
      }
    } catch (e) {
      // You can add a toast/snackbar provider here to show errors
      rethrow;
    }
  }

  /// Signs out and WIPES local data
  Future<void> signOut() async {
    // 1. Sign out from Cloud
    final authRepo = _ref.read(authRepositoryProvider);
    await authRepo.signOut();

    // 2. Wipe Local Database (Privacy / Clean Slate)
    final db = _ref.read(databaseProvider);
    await db.clearAllData();
  }
}