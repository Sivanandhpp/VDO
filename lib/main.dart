// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdo/firebase_options.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/core/user_data.dart';
import 'package:vdo/core/wrapper.dart';
import 'package:vdo/theme/app_theme.dart';

late SharedPreferences spInstance;
late DatabaseReference dbReference;
int? themeMode = 1;

UserData userData = UserData();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  dbReference = FirebaseDatabase.instance.ref();
  spInstance = await SharedPreferences.getInstance();
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  getTheme() {
    if (spInstance.containsKey('theme')) {
      themeMode = spInstance.getInt('theme');
      if (themeMode == 0) {
        _themeMode = ThemeMode.dark;
      } else if (themeMode == 1) {
        _themeMode = ThemeMode.system;
      } else if (themeMode == 2) {
        _themeMode = ThemeMode.light;
      }
    } else {
      spInstance.setInt('theme', 1);
      _themeMode = ThemeMode.system;
    }
  }

  createDir() async {
    final tempDir = await getTemporaryDirectory();
    if (await Directory('${tempDir.path}/VDO/decrypted').exists()) {
      final tempDirec = tempDir.path;
    } else {
      Directory('${tempDir.path}/VDO/decrypted').create(recursive: true);
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    if (await Directory('${appDocDir.path}/VDO/encrypted').exists()) {
      final appDocDirr = appDocDir.path;
    } else {
      Directory('${appDocDir.path}/VDO/encrypted').create(recursive: true);
      final appDocDirr = appDocDir.path;
    }
  }

  @override
  void initState() {
    super.initState();
    getTheme();
    createDir();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'VDO',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeMode,
          home: Wrapper()),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
