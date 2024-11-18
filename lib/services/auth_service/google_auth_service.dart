import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async{
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken,
          idToken: gAuth?.idToken
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      print(e);
      throw e;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  /// Logout do Firebase e Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// Login silencioso
  Future<UserCredential?> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signInSilently();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Erro no login silencioso: $e');
      return null;
    }
  }
}