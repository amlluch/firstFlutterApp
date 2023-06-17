import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logged_user.dart';

class UserPasswordRegister extends StatefulWidget {
  const UserPasswordRegister({Key? key}) : super(key: key);

  @override
  _UserPasswordRegisterState createState() => _UserPasswordRegisterState();
}

class _UserPasswordRegisterState extends State<UserPasswordRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_passwordController.text != _repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Las contraseñas no coinciden. Inténtelo de nuevo.')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Obtener el token de usuario
      String? token = await userCredential.user?.getIdToken();

      // Guardar el token en SharedPreferences
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        // Navegar a la pantalla LoggedScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoggedScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El usuario ya existe.')));
      } else {
        // Aquí se pueden manejar los diferentes errores de FirebaseAuth.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear el usuario. Inténtelo de nuevo.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repeatPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Repetir Contraseña',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, repite tu contraseña';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}