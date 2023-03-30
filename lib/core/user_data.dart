import 'package:vdo/core/db_service.dart';

class UserData {
  late String name, email, phoneNo, password, userid, profile, dob;

  DatabaseService dbService = DatabaseService();

  snapshotToClass(uid, snapshot) {
    name = snapshot.child('name').value;
    email = snapshot.child('email').value;
    phoneNo = snapshot.child('phone').value;
    profile = snapshot.child('profile').value;
    dob = snapshot.child('dob').value;
  }

  setUserData(String uid, String setname, String setemail, String setphoneNo,
      String setprofile, String setdob, bool setData) {
    userid = uid;
    name = setname;
    email = setemail;
    phoneNo = setphoneNo;
    profile = setprofile;
    dob = setdob;

    if (setData) {
      //SET DATA TO REALTIME DATABASE WHILE SIGN UP
      dbService.setDatabaseUser(
          uid, setname, setemail, setphoneNo, profile, dob);
    }
  }
}
