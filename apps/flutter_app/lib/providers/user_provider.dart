import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';

final userDataProvider = FutureProvider<AppUser?>((ref) async {
  
  // 1. Check Firebase Auth stream first
  final firebaseUser = ref.watch(authStreamProvider).value;
  
  if (firebaseUser == null) {
    return null; // Instantly return Guest state!
  }

  final repo = await ref.watch(userRepositoryProvider.future);
  
  // 2. Try local database cache
  try {
    final localUser = await repo.getLocalUser(); 
    if (localUser != null) {
      return localUser;
    }
  } catch (_) {}

  // 3. Try to fetch from server with a 5-second timeout
  try {
    return await repo.getUserData().timeout(const Duration(seconds: 5));
  } catch (e) {
    // 4. OFFLINE FALLBACK: 
    // Create a temporary AppUser using Google's data matching YOUR exact model!
    
    final displayName = firebaseUser.displayName ?? 'Offline User';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : 'Offline';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    return AppUser(
      id: firebaseUser.uid,
      language: 'en', // Default fallback language
      friendCode: 'OFFLINE', // This triggers your offline Social Screen UI!
      email: firebaseUser.email ?? '',
      firstName: firstName,
      lastName: lastName,
      registeredAt: DateTime.now(), 
    );
  }
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(userDataProvider).value?.id;
});