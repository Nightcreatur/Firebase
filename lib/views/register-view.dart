import 'package:dart/constansts/routes.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:dart/utilities/show_error_dialouge.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Email', icon: Icon(Icons.email)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            hintText: 'Password', icon: Icon(Icons.password)),
                      ),
                    ),
                    TextButton(
                      child: const Text('Register'),
                      onPressed: (() async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase()
                              .createUser(email: email, password: password);
                          AuthService.firebase().sendEmailVerification();

                          Navigator.of(context).pushNamed(
                            verifyEmail,
                          );
                        } on WeakPasswordAuthException {
                          await showErrorDialog(context,
                              'Weak password try some strong password');
                        } on EmailAlreadyAuthException {
                          await showErrorDialog(
                              context, 'Email already in use');
                        } on InvalidEmailAuthException {
                          await showErrorDialog(context, 'Invalid email');
                        } on GenericAuthException {
                          await showErrorDialog(context, 'Registration error!');
                        }
                      }),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        },
                        child: const Text('Already have account ? Login here!'))
                  ],
                );
              default:
                return const Text('Loading login');
            }
          }),
    );
  }
}
