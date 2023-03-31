import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/core/db_service.dart';
import 'package:vdo/widgets/snackbar_widget.dart';
import 'package:vdo/theme/theme_color.dart';
import 'package:vdo/core/wrapper.dart';
import 'package:vdo/screens/login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNO;
  const OtpScreen(
      {super.key, required this.verificationId, required this.phoneNO});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthService auth = AuthService();
  ShowSnackbar show = ShowSnackbar();

  DatabaseService dbService = DatabaseService();

  String? otpCode;
  TextEditingController pinController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset('assets/otp.jpg'),
                const Text(
                  "Welcome to VDO",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "We've sent an OTP to ${widget.phoneNO}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Pinput(
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  controller: pinController,
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ThemeColor.primary)),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  onCompleted: (value) {
                    otpCode = value;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (otpCode != null) {
                      auth.verifyOTP(context, widget.verificationId, otpCode!);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Wrapper(),
                          ));
                    } else {
                      show.snackbar(context, 'Please enter 6 digit OTP');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ThemeColor.primary),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: const Text(
                      "Change number?",
                      style: TextStyle(
                          color: ThemeColor.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
