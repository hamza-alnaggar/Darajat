import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    signInOption: SignInOption.standard, // Force standard sign-in flow
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Force sign out first to ensure clean state
      await _googleSignIn.signOut();
      
      // Show the sign-in dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Sign in cancelled by user');
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In Error: $e');
      throw Exception('فشل تسجيل الدخول باستخدام Google: $e');
    }
  }
  

}