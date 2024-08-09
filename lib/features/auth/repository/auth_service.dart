// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// authServiceProvider is a provider that return AuthService
final authServiceProvider = Provider((ref) => AuthService(
      auth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ));

// class AuthService is a class that return signInWithGoogle method
class AuthService {
  FirebaseAuth auth;
  GoogleSignIn googleSignIn;
  AuthService({
    required this.auth,
    required this.googleSignIn,
  });

  signInWithGoogle() async {
    // sign in pop a widow to choose account user save what account user choose
    final user = await googleSignIn.signIn();
    // with authentication user can get access token and id token
    final googleAuth = await user!.authentication;
    // create credential with access token and id token
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // sign in with credential user can sign in with google account and save user in firebase
    await auth.signInWithCredential(credential);
  }
}
