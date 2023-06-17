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

  @override
  void initState() {
    super.initState();
    _loadEndpoint();
  }

  void _loadEndpoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? endpoint = prefs.getString('end_point');
    if (endpoint != null) {
      _endpointController.text = endpoint;
    }
  }

  void _saveEndpoint() async {
    String endpoint = _endpointController.text;
    if (Uri.parse('https://'+endpoint).isAbsolute) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('end_point', endpoint);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Login Page')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter endpoint'),
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
