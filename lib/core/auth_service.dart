import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:vdo/core/err_handler.dart';
import 'package:vdo/core/user_model.dart';
import 'package:vdo/screens/otp_screen.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  // DatabaseService dbService = DatabaseService();
  ErrorHandler errHandler = ErrorHandler();
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
        errHandler.fromErrorCode(e, context);
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
        // String smsCode = 'xxxx';

        // auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);

        // await _firebaseAuth.signInWithCredential(credential);
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
    try {
      auth.User user = (await _firebaseAuth.signInWithCredential(cred)).user!;
    } on auth.FirebaseAuthException catch (e) {
      errHandler.fromErrorCode(e, context);
    } catch (e) {
      errHandler.fromErrorCode(e, context);
    }

    // await _firebaseAuth.signInWithCredential(auth.PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: otp));
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
