import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';

/// This provider fetches and holds the authenticated user's data.
/// It will be invalidated on sign-out, and refetched on sign-in.
final userDataProvider = FutureProvider<AppUser>((ref) async {
  final repository = await ref.watch(userRepositoryProvider.future);
  return repository.getUserData();
});

/// This provider gives synchronous access to the current user's ID.
/// It will be null if the user is loading or has an error.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(userDataProvider).value?.id;
});