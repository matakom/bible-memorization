import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';

class UserDataNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    // 1. Watch the actual Firebase User object
    final authUser = ref.watch(authStreamProvider).value;

    // 2. If no Firebase user, we are definitely a Guest
    if (authUser == null) {
      return null; 
    }

    // 3. Try to get the saved profile from SQLite
    final repo = await ref.watch(userRepositoryProvider.future);
    final localUser = await repo.getLocalUser();

    if (localUser != null) {
      return localUser; // Normal flow
    }

    // 4. OFFLINE FALLBACK: We are logged into Firebase, but the server 
    // was down during the initial fetch. Create a temporary profile!
    final nameParts = (authUser.displayName ?? 'Offline User').split(' ');
    
    return AppUser(
      id: authUser.uid,
      email: authUser.email ?? '',
      firstName: nameParts.isNotEmpty ? nameParts.first : 'Offline',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      language: 'cz', // Default fallback
      friendCode: '', // Leave empty so SocialScreen knows we haven't fully synced
      registeredAt: DateTime.now(),
    );
  }
}

final userDataProvider = AsyncNotifierProvider<UserDataNotifier, AppUser?>(() {
  return UserDataNotifier();
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(userDataProvider).value?.id;
});