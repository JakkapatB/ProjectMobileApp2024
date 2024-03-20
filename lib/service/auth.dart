import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_mobile/components/navbar.dart';
import 'package:project_mobile/pages/login.dart';
import 'package:project_mobile/service/database.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        final UserCredential result =
            await _auth.signInWithCredential(credential);
        final User? userDetails = result.user;
        if (userDetails != null) {
          final userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "imgUrl": userDetails.photoURL,
            "id": userDetails.uid,
          };
          await DatabaseMethods().addUser(userDetails.uid, userInfoMap);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navbar()));
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
