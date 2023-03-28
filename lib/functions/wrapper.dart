import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdo/functions/db_service.dart';
import 'package:vdo/screens/home_screen.dart';
import 'package:vdo/functions/auth_service.dart';
import 'package:vdo/screens/login_screen.dart';
import 'package:vdo/functions/user_model.dart';
import 'package:vdo/screens/signup_screen.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    DatabaseService dbService = DatabaseService();
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          print(user?.uid);
          if (user != null) {
            return FutureBuilder<bool?>(
              future: dbService.getUserInRtdb(user.uid),
              builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.toString() == "true") {
                    return HomeScreen();
                  } else {
                    return SignupScreen();
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return LoginScreen();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
