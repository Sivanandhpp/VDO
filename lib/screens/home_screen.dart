import 'package:flutter/material.dart';
import 'package:vdo/functions/auth_service.dart';
import 'package:vdo/screens/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("HOOOOME"),
              OutlinedButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  child: Text("Signout")),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoApp(),
                        ));
                  },
                  child: Text("Video"))
            ],
          ),
        ),
      )),
    );
  }
}
