import 'package:vdo/functions/err_handler.dart';
import 'package:vdo/functions/user_data.dart';
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
    String password,
    String profile,
  ) {
    final userReferance = dbReference.child('users/$uid');

    userReferance.set({
      'name': name,
      'email': email,
      'phone': phoneNo,
      'password': password,
      'profile': profile,
    });
  }

  Future<bool?> getUserInRtdb(String uid) async {
    var snapshot = await dbReference.child(uid).once();
    print(snapshot);
    print("yoooo");
    return true;
    // this print statement returns false if the child is not found
    // returns true if the child is found
  }

  updateVDO(String fileName, String key, String value) {
    final vdoReferance = dbReference.child('vdos/$fileName');
    print(fileName);
    vdoReferance.update({key: value});
  }
}
