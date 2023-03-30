import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/functions/db_service.dart';
import 'package:vdo/functions/theme_color.dart';

class AddVideo extends StatelessWidget {
  AddVideo({super.key});
  final TextEditingController _fileNameTextController = TextEditingController();
  final TextEditingController _fileLinkTextController = TextEditingController();
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
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
                    "Add Video",
                    style: GoogleFonts.ubuntu(
                      color: ThemeColor.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: ThemeColor.shadow,
                      blurRadius: 10,
                      spreadRadius: 0.1,
                      offset: Offset(0, 10)),
                ],
                color: ThemeColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: TextField(
                    controller: _fileNameTextController,
                    onChanged: (value) {},
                    showCursor: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      hintText: "Enter File Name",
                      hintStyle: GoogleFonts.ubuntu(color: ThemeColor.black),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: ThemeColor.shadow,
                      blurRadius: 10,
                      spreadRadius: 0.1,
                      offset: Offset(0, 10)),
                ],
                color: ThemeColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: TextField(
                    controller: _fileLinkTextController,
                    onChanged: (value) {},
                    showCursor: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      hintText: "Paste File Link",
                      hintStyle: GoogleFonts.ubuntu(color: ThemeColor.black),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                if (_fileNameTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      backgroundColor: ThemeColor.primary,
                      content: Text(
                        'Please enter file name',
                        style: TextStyle(color: ThemeColor.white),
                      )));
                } else if (_fileLinkTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      backgroundColor: ThemeColor.primary,
                      content: Text(
                        'Please paste file link',
                        style: TextStyle(color: ThemeColor.white),
                      )));
                } else {
                  dbService.updateVDO(_fileNameTextController.text, "url",
                      _fileLinkTextController.text);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      backgroundColor: ThemeColor.primary,
                      content: Text(
                        'Video added successfully!',
                        style: TextStyle(color: ThemeColor.white),
                      )));
                  Navigator.pop(context);
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
    )));
  }
}
