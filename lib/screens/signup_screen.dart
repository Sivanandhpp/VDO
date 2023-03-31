import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/core/db_service.dart';
import 'package:vdo/core/storage_service.dart';
import 'package:vdo/widgets/snackbar_widget.dart';
import 'package:vdo/theme/theme_color.dart';
import 'package:vdo/core/wrapper.dart';
import 'package:vdo/main.dart';

class SignupScreen extends StatefulWidget {
  final String phoneNO;
  const SignupScreen({super.key, required this.phoneNO});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthService auth = AuthService();
  ShowSnackbar show = ShowSnackbar();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool updatedProfile = false;
  String profileUrl = 'null';

  String selectedFileName = '';
  String selectedFilePath = '';
  Storage storage = Storage();
  DatabaseService dbService = DatabaseService();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _phoneNoController = TextEditingController(text: widget.phoneNO);
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 100, 1),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    "New here? Welcome!",
                    style: GoogleFonts.poppins(
                      // color: ThemeColor.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      "Please fill the form to continue.",
                      style: GoogleFonts.poppins(
                        color: ThemeColor.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowCompression: true,
                    allowMultiple: false,
                    type: FileType.image,
                  );
                  if (results == null) {
                    // ignore: use_build_context_synchronously
                    show.snackbar(context, 'No Image Selected');
                  } else {
                    setState(() {
                      isLoading = true;
                      selectedFileName = results.files.single.name;
                      selectedFilePath = results.files.single.path!;
                      String fileName = selectedFileName.trim();

                      storage
                          .uploadProfileImg(selectedFilePath, fileName, context)
                          .then(
                        (value) {
                          setState(
                            () {
                              isLoading = false;
                              updatedProfile = true;
                            },
                          );
                        },
                      );
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    isLoading
                        ? const CircleAvatar(
                            radius: 70,
                            // backgroundColor: Colors.white,
                            child: ClipOval(
                                child: CircularProgressIndicator(
                              color: ThemeColor.primary,
                            )),
                          )
                        : CircleAvatar(
                            radius: 75,
                            // backgroundColor: ThemeColor.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userData.profile,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  radius: 70,
                                  // backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image(
                                      image: AssetImage('assets/avatar.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: ThemeColor.primary,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 20,
                        // color: ThemeColor.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ///Name Input Field
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (_nameController.text.isEmpty) {
                          return "This field can't be empty";
                        }
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      cursorColor: ThemeColor.primary,
                      decoration: InputDecoration(
                        // fillColor: ThemeColor.textFieldBgColor,
                        filled: true,
                        hintText: "Full name",
                        hintStyle: GoogleFonts.poppins(
                          // color: ThemeColor.textFieldHintColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone Input Field
                    TextFormField(
                      controller: _phoneNoController,
                      validator: (value) {
                        if (_phoneNoController.text.isEmpty) {
                          return "This field can't be empty";
                        } else if (_phoneNoController.text.length < 10) {
                          return "Phone number must have 10 digits";
                        }
                      },
                      readOnly: true,
                      cursorColor: ThemeColor.primary,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        // fillColor: ThemeColor.textFieldBgColor,
                        filled: true,
                        hintText: "Phone No",
                        hintStyle: GoogleFonts.poppins(
                          // color: ThemeColor.textFieldHintColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ///E-mail Input Field
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (_emailController.text.isEmpty) {
                          return "This field can't be empty";
                        } else if (_emailController.text.split('@').last !=
                                'vdo.com' &&
                            _emailController.text.split('@').last !=
                                'gmail.com') {
                          return "Enter a valid G-Mail ID";
                        }
                      },
                      cursorColor: ThemeColor.primary,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        // fillColor: ThemeColor.textFieldBgColor,
                        filled: true,
                        hintText: "E-Mail",
                        hintStyle: GoogleFonts.poppins(
                          // color: ThemeColor.textFieldHintColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          // color: ThemeColor.textFieldBgColor,
                        ),
                        child: Text(
                          "Date of birth: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: GoogleFonts.poppins(
                            // color: ThemeColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // await auth.createUserWithEmailAndPassword(
                          //     _nameController.text,
                          //     _phoneNoController.text,
                          //     _emailController.text,

                          //     context);
                          // ignore: use_build_context_synchronously
                          userData.setUserData(
                              userData.userid,
                              _nameController.text,
                              _emailController.text,
                              widget.phoneNO,
                              userData.profile,
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              true);
                          // dbService.setDatabaseUser(
                          //     userData.userid,
                          //     _nameController.text,
                          //     _emailController.text,
                          //     widget.phoneNO,
                          //     userData.profile);

                          // dbService.updateDatabaseUser('profile',
                          //     userData.profile, userData.userid, context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Wrapper(),
                              ));
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
                            "Done",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  child: const Text("Signout")),
            ],
          ),
        ),
      )),
    );
  }
}
