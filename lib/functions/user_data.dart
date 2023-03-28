import 'package:vdo/functions/db_service.dart';


class UserData {
  late String name,
      email,
      phoneNo,
      password,
      batch,
      revision,
      role,
      userid,
      profile,
      status;

  DatabaseService dbService = DatabaseService();

  snapshotToClass(uid, snapshot) {
    name = snapshot.child('name').value;
    email = snapshot.child('email').value;
    phoneNo = snapshot.child('phone').value;
    password = snapshot.child('password').value;
    profile = snapshot.child('profile').value;
  }

  setUserData(
      String uid,
      String setname,
      String setemail,
      String setphoneNo,

      String setprofile,
      bool setData) {
    userid = uid;
    name = setname;
    email = setemail;
    phoneNo = setphoneNo;   
    profile = setprofile;

    if (setData) {
      //SET DATA TO REALTIME DATABASE WHILE SIGN UP
      dbService.setDatabaseUser(
          uid, setname, setemail, setphoneNo, profile);
    }
  }
}
