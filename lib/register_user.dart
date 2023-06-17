import 'package:first_flutter_app/user_password_register.dart';
import 'package:flutter/material.dart';

import 'google_register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: Center( // Utilizamos Center para centrar los widgets en la pantalla
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPasswordRegister()),
                );
              },
              child: const Text('Registrar con usuario y contraseña'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navega a GoogleRegisterScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoogleRegisterScreen()),
                );
              },
              child: const Text('Registrar con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
