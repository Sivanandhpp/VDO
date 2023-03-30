import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/theme/theme_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String? phNumber = "+91";
  AuthService auth = AuthService();
  String errorMsg = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset('assets/login.jpg'),
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
                const Text(
                  "Enter your phone number to Get Started!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 1,
                    bottom: 1,
                  ),
                  decoration: BoxDecoration(
                      color: ThemeColor.lightGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        phNumber = number.phoneNumber;
                      });
                    },
                    searchBoxDecoration: const InputDecoration(
                        prefixIcon: Icon(Icons.room_rounded),
                        label: Text("Search Country Code")),
                    selectorConfig: const SelectorConfig(
                      showFlags: true,
                      trailingSpace: false,
                      setSelectorButtonAsPrefixIcon: true,
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    inputDecoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone no",
                        hintStyle: TextStyle(
                          color: ThemeColor.black,
                        )),
                    cursorColor: ThemeColor.black,
                    textStyle: const TextStyle(
                        color: ThemeColor.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(
                        color: ThemeColor.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                phNumber!.length != 13
                    ? Text(errorMsg,
                        style: const TextStyle(
                            color: ThemeColor.ytRed,
                            fontWeight: FontWeight.w500))
                    : Container(),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    if (phNumber!.length == 13) {
                      setState(() {
                        isLoading = true;
                      });
                      auth.phoneAuthentication(phNumber!, context);
                    } else {
                      setState(() {
                        errorMsg = "Invalid Phone Number";
                      });
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 20,
                            color: ThemeColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: ThemeColor.primary,
                              borderRadius: BorderRadius.circular(15)),
                          child: isLoading
                              ? const Center(
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: ThemeColor.white,
                                      )),
                                )
                              : const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
