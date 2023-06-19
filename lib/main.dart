import 'package:first_flutter_app/register_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'endpoint_screen.dart';
import 'firebase_options.dart';
import 'logged_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Do nothing
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _home = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkEndpoint();
    });
  }

  void _checkEndpoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? endpoint = prefs.getString('end_point');

    setState(() {
      _home = endpoint != null
          ? const MyHomePage(title: 'Five point five Demo Login Page')
          : const EndpointScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Five point five Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _home,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _userController.text,
        password: _passwordController.text,
      );
      // Here it gets the user token
      String? token = await userCredential.user?.getIdToken();
      print(token);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoggedScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect username or password. Please try again"))
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        String? token = await userCredential.user?.getIdToken();

        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoggedScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User does not exist"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'User',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Send'),
                ),
                ElevatedButton(
                  onPressed: _loginWithGoogle,
                  child: const Text('Login with Google'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EndpointScreen()),
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
    );
  }
}
