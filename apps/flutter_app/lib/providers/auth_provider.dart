import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/data/repositories/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Stream providing real-time authentication state updates from Firebase.
final authStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Configures and provides the Google Sign-In instance using environment variables.
final googleSignInProvider = Provider<GoogleSignIn>((ref){
  GoogleSignIn googleSignIn = GoogleSignIn.instance;
  googleSignIn.initialize(serverClientId: dotenv.env['SERVER_CLIENT_ID']);
  return googleSignIn;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides the AuthRepository initialized with Firebase and Google Sign-In instances.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return AuthRepository(auth: auth, googleSignIn: googleSignIn);
});