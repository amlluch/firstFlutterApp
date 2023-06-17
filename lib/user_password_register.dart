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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match. Please try again.')));
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The user already exists.')));
      } else {
        // Aquí se pueden manejar los diferentes errores de FirebaseAuth.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error creating the user. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repeatPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Repeat Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please repeat your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}