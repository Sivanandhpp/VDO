import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:vdo/functions/user_model.dart';
import 'package:vdo/screens/otp_screen.dart';

// import 'err_handler.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  // DatabaseService dbService = DatabaseService();
  // ErrorHandler errHandler = ErrorHandler();
  var verificationId = '';

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.displayName, user.email, user.phoneNumber);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<void> phoneAuthentication(String phoneNo, BuildContext context) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (auth.PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (auth.FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNO: phoneNo,
              ),
            ));
        String smsCode = 'xxxx';

        auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        await _firebaseAuth.signInWithCredential(credential);
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String otp,
  ) async {
    auth.PhoneAuthCredential cred = auth.PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    auth.User user = (await _firebaseAuth.signInWithCredential(cred)).user!;
    
    // if (user != null) {
    // onSuccess(user.uid);
    // if (dbService.getUserInRtdb(user.uid)) {
    //   print("yooo");
    // }

    // _userFromFirebase(user);
    // }
    // await _firebaseAuth.signInWithCredential(auth.PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: otp));
  }

  Future<void> signOut() async {
    // spService.clearSharedprefUser();
    return await _firebaseAuth.signOut();
  }
}




  // Future<User?> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   try {
  //     final credential = await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return _userFromFirebase(credential.user);
  //   } on auth.FirebaseAuthException catch (e) {
  //     errHandler.fromErrorCode(e, context);
  //   } catch (e) {
  //     errHandler.fromErrorCode(e, context);
  //   }
  //   return null;
  // }

  // Future<User?> createUserWithEmailAndPassword(
  //     String name,
  //     String phoneNo,
  //     String email,
  //     String password,
  //     String batch,
  //     String revision,
  //     BuildContext context) async {
  //   // globals.userName = name;
  //   try {
  //     final credential = await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     credential.user!.linkWithPhoneNumber(phoneNo);
  //     credential.user!.updateDisplayName(name);
  //     // userData.setUserData(credential.user!.uid, name, email, phoneNo, password,
  //     //     batch, revision, 'user','null','active', true);
  //     return _userFromFirebase(credential.user);
  //   } on auth.FirebaseAuthException catch (e) {
  //     errHandler.fromErrorCode(e, context);
  //   } catch (e) {
  //     errHandler.fromErrorCode(e, context);
  //   }
  //   return null;
  // }