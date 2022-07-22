import 'package:dart/views/login.dart';
import 'package:dart/views/register-view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.teal),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const Login(),
      '/register/': (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // final user = FirebaseAuth.instance.currentUser;
              // if (user?.emailVerified ?? false) {
              //   print('You are verified');
              // } else {
              //   return const VerifyEmailView();
              // }
              return const Login();
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
