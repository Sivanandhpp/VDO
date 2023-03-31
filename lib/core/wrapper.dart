import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdo/core/db_service.dart';
import 'package:vdo/core/user_data.dart';
import 'package:vdo/main.dart';
import 'package:vdo/screens/home_screen.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/screens/login_screen.dart';
import 'package:vdo/core/user_model.dart';
import 'package:vdo/screens/signup_screen.dart';
import 'package:vdo/widgets/home_shimmer.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    DatabaseService dbService = DatabaseService();
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          final User? user = snapshot.data;
          if (user != null) {
            userData.userid = user.uid;
            userData.profile = "null";
            return FutureBuilder<bool?>(
              future: dbService.getUserInRtdb(user.uid),
              builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.toString() == "true") {
                    return FutureBuilder<UserData?>(
                        future: dbService.getDatabaseUser(user.uid),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserData?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const HomeScreen();
                          }
                          return const HomeShimmer();
                        });
                  } else {
                    return SignupScreen(phoneNO: user.phoneNo.toString());
                  }
                }
                return const HomeShimmer();
              },
            );
          }
          return const LoginScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
