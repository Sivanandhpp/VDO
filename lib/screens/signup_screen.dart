import 'package:flutter/material.dart';
import 'package:vdo/functions/auth_service.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text("signup"),
            OutlinedButton(
                onPressed: () {
                  auth.signOut();
                },
                child: Text("Signout")),
          ],
        ),
      )),
    );
  }
}
