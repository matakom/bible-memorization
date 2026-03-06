import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';

/// Provides the current application user profile, with an offline fallback for authenticated Firebase users.
class UserDataNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final authUser = ref.watch(authStreamProvider).value;
    if (authUser == null) return null; 

    final repo = await ref.watch(userRepositoryProvider.future);
    final localUser = await repo.getLocalUser();
    if (localUser != null) return localUser;

    final nameParts = (authUser.displayName ?? 'Offline User').split(' ');
    return AppUser(
      id: authUser.uid,
      email: authUser.email ?? '',
      firstName: nameParts.isNotEmpty ? nameParts.first : 'Offline',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      language: 'cz',
      friendCode: '',
      registeredAt: DateTime.now(),
    );
  }
}

final userDataProvider = AsyncNotifierProvider<UserDataNotifier, AppUser?>(UserDataNotifier.new);