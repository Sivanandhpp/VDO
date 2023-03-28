import 'package:flutter/foundation.dart';
import 'package:vdo/main.dart';

class DatabaseService {
  // ErrorHandler errHandler = ErrorHandler();
  // UserData userData = UserData();
  // Future<UserData> getDatabaseUser(String uid) async {
  //   await dbReference.child('users/$uid').once().then(
  //         (value) => userData.snapshotToClass(uid, value.snapshot),
  //       );
  //   return userData;
  // }

  setDatabaseUser(
    String uid,
    String name,
    String email,
    String phoneNo,
    String profile,
  ) {
    final userReferance = dbReference.child('users/$uid');

    userReferance.set({
      'name': name,
      'email': email,
      'phone': phoneNo,
      'profile': profile,
    });
  }

  Future<bool?> getUserInRtdb(String uid) async {
    var snapshot = await dbReference.child("users/$uid").once();
    if (snapshot.snapshot.value.toString() != "null") {
      return true;
    }
    return false;
  }

  updateVDO(String fileName, String key, String value) {
    final vdoReferance = dbReference.child('vdos/$fileName');
    vdoReferance.update({key: value});
  }
}
