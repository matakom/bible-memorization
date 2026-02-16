import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../data/models/user.dart';
import '../core/repository_providers.dart';

// 1. FIREBASE AUTH STREAM
// Listens to the cloud authentication state (Logged In / Logged Out).
final authStateProvider = StreamProvider<firebase.User?>((ref) {
  return firebase.FirebaseAuth.instance.authStateChanges();
});

// 2. LOCAL USER STREAM
// The "Source of Truth" for your UI.
// Waits for Firebase, then streams the profile from SQLite.
final currentUserProvider = StreamProvider<User?>((ref) async* {
  // A. Wait for Firebase Auth to settle
  final authState = await ref.watch(authStateProvider.future);
  
  // B. If not logged in, we have no user.
  if (authState == null) {
    yield null;
  } else {
    // C. If logged in, watch the Local DB for profile changes.
    final db = ref.watch(databaseProvider);
    
    // Ensure UsersDao has: Stream<User?> watchCurrentUser()
    yield* db.usersDao.watchCurrentUser().map((row) {
      if (row == null) return null;
      
      return User(
        id: row.id,
        email: row.email,
        firstName: row.firstName,
        lastName: row.lastName,
        friendCode: row.friendCode,
        score: row.score,
        targetRetention: row.targetRetention,
        userMemoryFactor: row.userMemoryFactor,
        language: row.language,
      );
    });
  }
});