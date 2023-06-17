import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class EndpointScreen extends StatefulWidget {
  const EndpointScreen({Key? key}) : super(key: key);

  @override
  _EndpointScreenState createState() => _EndpointScreenState();
}

class _EndpointScreenState extends State<EndpointScreen> {
  final TextEditingController _endpointController = TextEditingController();

  void _saveEndpoint() async {
    String endpoint = _endpointController.text;
    if (Uri.parse(endpoint).isAbsolute) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('end_point', endpoint);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Login Page')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, introduce una URL válida.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introducir endpoint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'User endpoint url',
              ),
            ),
            ElevatedButton(
              onPressed: _saveEndpoint,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}