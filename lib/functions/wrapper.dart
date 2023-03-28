import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdo/screens/home_screen.dart';
import 'package:vdo/functions/auth_service.dart';
import 'package:vdo/screens/login_screen.dart';
import 'package:vdo/functions/user_model.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user != null) {
            // userData.userid = user.uid;
            // return FutureBuilder<UserData>(
            //   future: dbService.getDatabaseUser(user.uid),
            //   builder:
            //       (BuildContext context, AsyncSnapshot<UserData> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.data!.status == "disabled") {
            //         return const DisabledAccount();
            //       } else {
            //         if (snapshot.data!.role == "admin") {
            //           //Admin Dashboard
            //           return AdminDashBoard();
            //         } else {
            //           //User Dashboard
            //           return UserDashBoard();
            //         }
            //       }
            //     }
            //     return const HomeShimmer();
            //   },
            // );
            return HomeScreen();
          }
          // if (user == null) {
          //   return FutureBuilder<bool?>(
          //     future: spService.getFirstSeen(),
          //     builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.data == false) {
          //           return const IntroScreen();
          //         } else {
          //           return const LoginPage();
          //         }
          //       }
          //       return const LoadingScreen(
          //         loadingTitle: "Redirecting...",
          //       );
          //     },
          //   );
          // }
          return LoginScreen();
        }
        // return const LoadingScreen(
        //   loadingTitle: "Initializing...",
        // );
        return LoginScreen();
      },
    );
  }
}
