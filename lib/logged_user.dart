import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class LoggedScreen extends StatefulWidget {
  const LoggedScreen({super.key});

  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Agrega la instancia de FirebaseAuth
  String? _response;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      var response = await http.get(
        Uri.parse('https://izpqksq5sg.execute-api.eu-west-1.amazonaws.com/prod/user'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var decodedTokenString = jsonResponse['requestContext']['authorizer']['decodedToken'];
        var decodedToken = jsonDecode(decodedTokenString);
        String uid = decodedToken['uid'];

        setState(() {
          _response = uid;
        });
      }
    }
  }

  // Método para cerrar la sesión y navegar de nuevo a la pantalla de inicio
  void _logout() async {
    await _auth.signOut();

    // Borra el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Login Page')),
          (route) => false, // No permite regresar a la pantalla anterior
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _response != null
                ? Text('User ID: $_response')
                : CircularProgressIndicator(),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
