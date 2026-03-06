import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Manages authentication via Firebase and Google Sign-In.
class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : _auth = auth,
        _googleSignIn = googleSignIn;

  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication authentication = account.authentication;
    final AuthCredential credentials = GoogleAuthProvider.credential(idToken: authentication.idToken);
    await _auth.signInWithCredential(credentials);
    
    if(_auth.currentUser != null){
      return await _auth.currentUser!.getIdToken();
    }
    return null;
  }

  Future<String?> getAuthToken() async {
    if (_auth.currentUser != null) {
      return await _auth.currentUser!.getIdToken(false);
    }
    return null;
  }
  
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}