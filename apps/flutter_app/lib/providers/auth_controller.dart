import 'package:flutter_app/data/repositories/user_repository.dart'; //
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_app/providers/settings/settings_loading_provider.dart';
import 'package:flutter_app/providers/user_provider.dart'; // Import our new provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends Notifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> signInWithGoogle() async {
    ref.read(settingsLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      
      ref.invalidate(userRepositoryProvider);
      ref.invalidate(userDataProvider);
      ref.invalidate(friendshipsProvider);
      
      await ref.read(userDataProvider.future);

    } catch (e) {
      // TODO Handle error
    } finally {
      ref.read(settingsLoadingProvider.notifier).state = false;
    }
  }

  Future<void> signOut() async {
    ref.read(settingsLoadingProvider.notifier).setLoading(true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      _invalidateUserData();
    } catch (e) {
      // Rethrow so the UI can catch it
      rethrow; 
    } finally {
      ref.read(settingsLoadingProvider.notifier).setLoading(false);
    }
  }

  void _invalidateUserData() {
    ref.invalidate(userRepositoryProvider);
    ref.invalidate(userDataProvider);
    ref.invalidate(friendshipsProvider); 
  }

}

final authControllerProvider = NotifierProvider<AuthController, void>(() {
  return AuthController();
});