import 'package:first_flutter_app/user_password_register.dart';
import 'package:flutter/material.dart';

import 'google_register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center( // We use Center to center the widgets on the screen.
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
              child: const Text('Register with user and password'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navega a GoogleRegisterScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoogleRegisterScreen()),
                );
              },
              child: const Text('Register with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
