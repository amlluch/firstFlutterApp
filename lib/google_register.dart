import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logged_user.dart'; // Asegúrate de que 'logged_screen.dart' es correcto.

class GoogleRegisterScreen extends StatelessWidget {
  const GoogleRegisterScreen({Key? key}) : super(key: key);

  Future<void> _registerWithGoogle(BuildContext context) async { // Aquí hemos añadido BuildContext como parámetro.
    try {
      // Inicializa GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Intenta iniciar sesión
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Si el usuario cancela la operación, googleUser será null
      if (googleUser != null) {
        // Obtén la autenticación
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Crea una nueva credencial
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Inicia sesión con las nuevas credenciales
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Obtén el token del usuario
        String? token = await userCredential.user?.getIdToken();

        // Guarda el token en SharedPreferences
        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);

          // Navega a la pantalla LoggedScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoggedScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión con Google.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar con Google'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _registerWithGoogle(context), // Aquí pasamos el contexto a _registerWithGoogle.
          child: const Text('Registrar con Google'),
        ),
      ),
    );
  }
}
