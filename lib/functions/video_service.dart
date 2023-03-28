// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as enc;

class VideoService {
  // String filename = "demo.mp4";
  // final String _videoURL = "";
  // "https://assets.mixkit.co/videos/preview/mixkit-clouds-and-blue-sky-2408-large.mp4";

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

  Future<bool?> download(String videoURL, String fileName) async {
    //To access visible directory
    Directory d = await getExternalVisibleDir;

    //App directory : will not be visible but secured
    // Directory d = await getAppDir;

    return _downloadAndCreate(videoURL, d, fileName);
  }

  Future<bool?> getVideo(String fileName) async {
    //To access visible directory
    Directory d = await getExternalVisibleDir;

    //App directory : will not be visible but secured
    // Directory d = await getAppDir;

    return _getNormalFile(d, fileName);
  }

  Future<bool> _downloadAndCreate(String url, Directory d, filename) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print("Data downloading....");
      var resp = await http.get(Uri.parse(url));

      var encResult = _encryptData(resp.bodyBytes);
      String p = await _writeData(encResult, '${d.path}/$filename.aes');
      // String p = await _writeData(encResult, '/storage/emulated/0/VDO/demo.mp4.aes');
      print("file encrypted successfully: $p");
      return true;
    } else {
      print("Can't launch URL.");
      return false;
    }
  }

  _getNormalFile(Directory d, filename) async {
    Uint8List encData = await _readData('${d.path}/$filename.aes');
    // Uint8List encData = await _readData('/storage/emulated/0/VDO/demo.mp4.aes');
    var plainData = await _decryptData(encData);
    String p = await _writeData(plainData, '${d.path}/$filename');
    // p = await _writeData(plainData, '/storage/emulated/0/VDO/demo.mp4');
    print("file decrypted successfully: $p");
    return true;
  }

  _encryptData(plainString) {
    print("Encrypting File...");
    final encrypted =
        MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
    return encrypted.bytes;
  }

  _decryptData(encData) {
    print("File decryption in progress...");
    enc.Encrypted en = enc.Encrypted(encData);
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
}

class MyEncrypt {
  static final myKey = enc.Key.fromUtf8('54m9133ncryp710nk3y8y51V4N4NDH99');
  static final myIv = enc.IV.fromUtf8("9R0J3CT51V4N4NDH");
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}