import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoggedScreen extends StatefulWidget {
  const LoggedScreen({super.key});

  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
      ),
      body: Center(
        child: _response != null
            ? Text('User ID: $_response')
            : CircularProgressIndicator(),
      ),
    );
  }
}
