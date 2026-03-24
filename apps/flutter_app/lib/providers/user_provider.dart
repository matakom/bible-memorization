import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';

/// Provides the current application user profile, with an offline fallback for authenticated Firebase users.
final userDataProvider = StreamProvider<AppUser?>((ref) {
  final authAsync = ref.watch(authStreamProvider);

  return authAsync.maybeWhen(
    data: (authUser) {
      if (authUser == null) {
        return Stream.value(null);
      }

      final repoAsync = ref.watch(userRepositoryProvider);

      return repoAsync.maybeWhen(
        data: (repo) {
          return repo.watchLocalUser();
        },
        orElse: () {
          return const Stream.empty();
        },
      );
    },
    orElse: () => const Stream.empty(),
  );
});
