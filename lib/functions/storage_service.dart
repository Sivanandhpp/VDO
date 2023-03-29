import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:vdo/functions/db_service.dart';
import 'package:vdo/functions/err_handler.dart';
import 'package:vdo/main.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  ErrorHandler errHandler = ErrorHandler();
  DatabaseService dbService = DatabaseService();

  //TO HANDLE PROFILE IMAGE
  Future<String> uploadProfileImg(
      String filePath, String fileName, BuildContext context) async {
    File file = File(filePath);
    String fileNamePursed = fileName.replaceAll(RegExp('\\s+'), 'x');
    String url =
        "https://firebasestorage.googleapis.com/v0/b/v-d-o-player.appspot.com/o/profile%2F$fileNamePursed?alt=media";
    userData.profile = url;
    try {
      await storage.ref('profile/$fileNamePursed').putFile(file).then((value) {
        
      });
    } on firebase_core.FirebaseException catch (e) {
      errHandler.fromErrorCode(e, context);
    }
    return url;
  }
}
