import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorHandler {
  ErrorPopup errPop = ErrorPopup();
  fromErrorCode(e, BuildContext context) {
    if (e.code == 'weak-password') {
      errPop.popupError(
          'Too weak password', 'The password provided is too weak.', context);
    } else if (e.code == 'email-already-in-use') {
      errPop.popupError('Account already exists',
          'The account already exists for that email.', context);
    } else if (e.code == 'user-not-found') {
      errPop.popupError(
          'Invalid EMail!', 'No user found for that email.', context);
    } else if (e.code == 'wrong-password') {
      errPop.popupError(
          'Wrong Password!', 'Wrong password provided for that user.', context);
    } else {
      errPop.popupError('Error!', e.toString(), context);
    }
  }
}


class ErrorPopup {
  popupError(String title, String err, BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(20.0),
        title: Text(
          title,
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        content: Text(err),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Got it!',
                  style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
