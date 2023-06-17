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
  final FirebaseAuth _auth = FirebaseAuth.instance; // It adds FirebaseAuth instance
  String? _response;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? endpoint = prefs.getString('end_point');

    if (token != null && endpoint != null) {
      var response = await http.get(
        Uri.parse(endpoint),
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

  // Method for logging out and navigating back to the home screen
  void _logout() async {
    await _auth.signOut();

    // Deletes token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Login Page')),
          (route) => false, // Does not allow to return to the previous screen
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
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
