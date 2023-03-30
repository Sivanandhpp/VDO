import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vdo/functions/auth_service.dart';
import 'package:vdo/functions/db_service.dart';
import 'package:vdo/functions/storage_service.dart';
import 'package:vdo/theme/theme_color.dart';
import 'package:vdo/functions/wrapper.dart';
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
  Widget getAvatar() {
    if (isLoading) {
      return const CircleAvatar(
        radius: 70,
        backgroundColor: Colors.white,
        child: ClipOval(
            child: CircularProgressIndicator(
          color: ThemeColor.primary,
        )),
      );
    }

    return CircleAvatar(
      radius: 75,
      backgroundColor: ThemeColor.white,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: userData.profile,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image(
                image: AssetImage('assets/images/avatar.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Profile",
                                style: GoogleFonts.ubuntu(
                                  color: ThemeColor.black,
                                  fontSize: 26,
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          backgroundColor: ThemeColor.primary,
                          content: Text(
                            'No Image Selected',
                            style: TextStyle(color: ThemeColor.white),
                          )));
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
                      isLoading
                          ? const CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                  child: CircularProgressIndicator(
                                color: ThemeColor.primary,
                              )),
                            )
                          : CircleAvatar(
                              radius: 75,
                              backgroundColor: ThemeColor.white,
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
                                    backgroundColor: Colors.white,
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
                    color: ThemeColor.black,
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
                    color: ThemeColor.black,
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
                    color: ThemeColor.black,
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
                    color: ThemeColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                // Text(
                //   "Batch: ${userData.batch} | Revision: ${userData.revision}",
                //   style: GoogleFonts.ubuntu(
                //     color: ThemeColor.black,
                //     fontSize: 20,
                //     fontWeight: FontWeight.normal,
                //   ),
                // ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: GestureDetector(
                    onTap: () {
                      // if (isLight) {
                      //   MyApp.of(context).changeTheme(ThemeMode.dark);
                      //   setState(() {
                      //     isLight = false;
                      //   });
                      // } else {
                      //   MyApp.of(context).changeTheme(ThemeMode.light);
                      //   setState(() {
                      //     isLight = true;
                      //   });
                      // }

                      // MyApp.of(context).changeTheme(ThemeMode.system);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: ThemeColor.lightGrey,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Switch Theme",
                          style:
                              TextStyle(fontSize: 15, color: ThemeColor.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
