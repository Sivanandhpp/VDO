import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vdo/core/auth_service.dart';
import 'package:vdo/core/db_service.dart';
import 'package:vdo/core/storage_service.dart';
import 'package:vdo/widgets/snackbar_widget.dart';
import 'package:vdo/theme/theme_color.dart';
import 'package:vdo/core/wrapper.dart';
import 'package:vdo/main.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  bool isLight = true;
  bool isLoading = false;
  bool updatedProfile = false;
  String profileUrl = 'null';
  String selectedFileName = '';
  String selectedFilePath = '';

  Storage storage = Storage();
  DatabaseService dbService = DatabaseService();
  ShowSnackbar show = ShowSnackbar();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (updatedProfile) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Wrapper(),
                              ));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 10, top: 10, bottom: 10),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  // color: Colors.black,
                                ),
                              ),
                              Text(
                                "Profile",
                                style: GoogleFonts.ubuntu(
                                  // color: ThemeColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        String fileName = selectedFileName.replaceAll(' ', '');

                        storage
                            .uploadProfileImg(
                                selectedFilePath, fileName, context)
                            .then(
                          (value) {
                            setState(
                              () {
                                dbService.updateDatabaseUser(
                                    "profile", value, userData.userid, context);
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
                      userData.profile.isEmpty
                          ? const CircleAvatar(
                              radius: 70,
                              // backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image(
                                  image: AssetImage('assets/avatar.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : isLoading
                              ? const CircleAvatar(
                                  radius: 70,
                                  // backgroundColor: Colors.white,
                                  child: ClipOval(
                                      child: CircularProgressIndicator(
                                    color: ThemeColor.primary,
                                  )),
                                )
                              : CircleAvatar(
                                  radius: 70,
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
                                            image:
                                                AssetImage('assets/avatar.jpg'),
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
                          color: ThemeColor.white,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userData.name,
                  style: GoogleFonts.ubuntu(
                    // color: ThemeColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Date of birth: ${userData.dob}",
                  style: GoogleFonts.ubuntu(
                    // color: ThemeColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Mail ID: ${userData.email}",
                  style: GoogleFonts.ubuntu(
                    // color: ThemeColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Phone No: ${userData.phoneNo}",
                  style: GoogleFonts.ubuntu(
                    // color: ThemeColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: GestureDetector(
                    onTap: () async {
                      await authService.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: ThemeColor.ytRed,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Sign Out",
                          style:
                              TextStyle(fontSize: 15, color: ThemeColor.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Switch Theme",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ToggleSwitch(
                  minWidth: 90.0,
                  minHeight: 70.0,
                  initialLabelIndex: themeMode,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 3,
                  icons: const [
                    Icons.dark_mode_rounded,
                    Icons.phone_android_rounded,
                    Icons.light_mode_rounded,
                  ],
                  iconSize: 30.0,
                  activeBgColors: const [
                    [Colors.black, Colors.black26],
                    [ThemeColor.primary, ThemeColor.secondary],
                    [Colors.yellow, Colors.orange]
                  ],
                  animate:
                      true, // with just animate set to true, default curve = Curves.easeIn
                  curve: Curves
                      .easeInOutBack, // animate must be set to true when using custom curve
                  onToggle: (index) {
                    if (index == 0) {
                      MyApp.of(context).changeTheme(ThemeMode.dark);
                      themeMode = 0;
                      spInstance.setInt("theme", 0);
                    } else if (index == 1) {
                      MyApp.of(context).changeTheme(ThemeMode.system);
                      themeMode = 1;
                      spInstance.setInt("theme", 1);
                    } else if (index == 2) {
                      MyApp.of(context).changeTheme(ThemeMode.light);
                      themeMode = 2;
                      spInstance.setInt("theme", 2);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
