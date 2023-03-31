import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vdo/firebase_options.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/core/user_data.dart';
import 'package:vdo/core/wrapper.dart';
import 'package:vdo/theme/theme_color.dart';

late DatabaseReference dbReference;
UserData userData = UserData();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  dbReference = FirebaseDatabase.instance.ref();
  await Permission.storage.request();
  runApp(const MyApp());
}

// requestStoragePermission() async {
//   if (!await Permission.storage.isGranted) {
//     await Permission.storage.request();
//     Permission.accessMediaLocation.request();
//     Permission.sms.request();
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
          theme: ThemeData(
              primaryColor: ThemeColor.primary,
              scaffoldBackgroundColor: ThemeColor.scaffoldBgColor),
          // darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,

          // ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          //   primarySwatch: Colors.blue,
          // ),
          home: Wrapper()),
    );
  }
}
