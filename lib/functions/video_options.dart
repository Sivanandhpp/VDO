import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as enc;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGranted = true;
  String filename = "demo.mp4";
  String _videoURL =
      "https://assets.mixkit.co/videos/preview/mixkit-clouds-and-blue-sky-2408-large.mp4";

  Future<Directory> get getAppDir async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/VDO').exists()) {
      final externalDir = Directory('/storage/emulated/0/VDO');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/VDO').create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/VDO');
      return externalDir;
    }
  }

  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      Permission.accessMediaLocation.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        setState(() {
          _isGranted = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    requestStoragePermission();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text("Download & Encrypt"),
              onPressed: () async {
                if (_isGranted) {

                  //To access visinle directory
                  // Directory d = await getExternalVisibleDir;
                  
                  //App directory : will not be visible but secured
                  Directory d = await getAppDir;

                  _downloadAndCreate(_videoURL, d, filename);
                  
                } else {
                  print("No permission granted.");
                  requestStoragePermission();
                }
              },
            ),
            OutlinedButton(
              child: Text("Decrypt File"),
              onPressed: () async {
                if (_isGranted) {
                  Directory d = await getExternalVisibleDir;
                  /*
                  Uncomment below line and comment above line to use Application Hidden Directory 
                  to store files (Recomanded).
                  
                  You will not able to view Encrypted files and decrepted files if you use Application Directory
                  */

                  // Directory hiddenDir = await getAppDir;
                  _getNormalFile(d, filename);
                } else {
                  print("No permission granted.");
                  requestStoragePermission();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

_downloadAndCreate(String url, Directory d, filename) async {
  if (await canLaunch(url)) {
    print("Data downloading....");
    var resp = await http.get(Uri.parse(url));

    var encResult = _encryptData(resp.bodyBytes);
    String p = await _writeData(encResult, d.path + '/$filename.aes');
    // String p = await _writeData(encResult, '/storage/emulated/0/VDO/demo.mp4.aes');
    print("file encrypted successfully: $p");
  } else {
    print("Can't launch URL.");
  }
}

_getNormalFile(Directory d, filename) async {
  Uint8List encData = await _readData(d.path + '/$filename.aes');
  // Uint8List encData = await _readData('/storage/emulated/0/VDO/demo.mp4.aes');
  var plainData = await _decryptData(encData);
  String p = await _writeData(plainData, d.path + '/$filename');
  p = await _writeData(plainData, '/storage/emulated/0/VDO/demo.mp4');
  print("file decrypted successfully: $p");
}

_encryptData(plainString) {
  print("Encrypting File...");
  final encrypted =
      MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
  return encrypted.bytes;
}

_decryptData(encData) {
  print("File decryption in progress...");
  enc.Encrypted en = new enc.Encrypted(encData);
  return MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
}

Future<Uint8List> _readData(fileNameWithPath) async {
  print("Reading data...");
  File f = File(fileNameWithPath);
  return await f.readAsBytes();
}

Future<String> _writeData(dataToWrite, fileNameWithPath) async {
  print("Writting Data...");
  File f = File(fileNameWithPath);
  await f.writeAsBytes(dataToWrite);
  return f.absolute.toString();
}

class MyEncrypt {
  static final myKey = enc.Key.fromUtf8('TechWithVPTechWithVPTechWithVP12');
  static final myIv = enc.IV.fromUtf8("VivekPanchal1122");
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}
