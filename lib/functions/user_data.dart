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

  // updateRevision(String updatedRevision, BuildContext context) {
  //   revision = updatedRevision;
  //   dbService.updateDatabaseUser("revision", updatedRevision, userid, context);
  // }

  snapshotToClass(uid, snapshot) {
    name = snapshot.child('name').value;
    email = snapshot.child('email').value;
    phoneNo = snapshot.child('phone').value;
    password = snapshot.child('password').value;

    profile = snapshot.child('profile').value;
 
    // spService.setSharedprefUser(
    //     uid, name, email, phoneNo, password, batch, revision, role);
  }

  setUserData(
      String uid,
      String setname,
      String setemail,
      String setphoneNo,
      String setpassword,
    
      String setprofile,
    
      bool setData) {
    userid = uid;
    name = setname;
    email = setemail;
    phoneNo = setphoneNo;
    password = setpassword;
    
    profile = setprofile;


    if (setData) {
      //SET DATA TO SHARED PREFERANCES WHILE SIGN UP
      // spService.setSharedprefUser(uid, setname, setemail, setphoneNo,
      //     setpassword, setbatch, setrevision, setrole);

      //SET DATA TO REALTIME DATABASE WHILE SIGN UP
      dbService.setDatabaseUser(
          uid, setname, setemail, setphoneNo, setpassword, profile);
    }
  }
}
