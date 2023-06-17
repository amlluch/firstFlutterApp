import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logged_user.dart';

class GoogleRegisterScreen extends StatelessWidget {
  const GoogleRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Declare a local function inside `build` so that you can use `context`.
    Future<void> _registerWithGoogle(BuildContext context) async {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          String? token = await userCredential.user?.getIdToken();

          if (token != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', token);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoggedScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error logging in with Google.')));
      }
    }

    // It calls the function as soon as the widget is built.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _registerWithGoogle(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registering with Google...'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
