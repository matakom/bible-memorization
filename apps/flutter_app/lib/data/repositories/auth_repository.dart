import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Manages authentication via Firebase and Google Sign-In.
class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseAuth auth,
  }) : _auth = auth;

  Future<String?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(); 
      final GoogleSignInAccount? account = await googleSignIn.authenticate(); 
      if (account == null) {
        return null;
      }
      final clientAuth = await account.authorizationClient.authorizeScopes(['email', 'profile']);
      final GoogleSignInAuthentication authentication = await account.authentication;
      final AuthCredential credentials = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: clientAuth.accessToken,
      );
      await _auth.signInWithCredential(credentials);
      
      if(_auth.currentUser != null){
        final token = await _auth.currentUser!.getIdToken();
        return token;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getAuthToken() async {
    if (_auth.currentUser != null) {
      return await _auth.currentUser!.getIdToken(false);
    }
    return null;
  }
  
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}