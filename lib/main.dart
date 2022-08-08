import 'package:dart/constansts/routes.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/views/login.dart';
import 'package:dart/views/notes_view.dart';
import 'package:dart/views/register-view.dart';
import 'package:dart/views/verify_view.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.teal),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const Login(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmail: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const Login();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
