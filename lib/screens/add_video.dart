import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/core/db_service.dart';
import 'package:flutter/services.dart';
import 'package:vdo/widgets/snackbar_widget.dart';
import 'package:vdo/theme/theme_color.dart';

class AddVideo extends StatelessWidget {
  AddVideo({super.key});
  final TextEditingController _fileNameTextController = TextEditingController();
  final TextEditingController _fileLinkTextController = TextEditingController();
  DatabaseService dbService = DatabaseService();
  ShowSnackbar show = ShowSnackbar();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
                          size: 20,
                          // color: Colors.black,
                        ),
                      ),
                      Text(
                        "Add Video",
                        style: GoogleFonts.ubuntu(
                          // color: ThemeColor.black,
                          fontSize: 20,
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
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    // boxShadow: const [
                    //   BoxShadow(
                    //       color: ThemeColor.shadow,
                    //       blurRadius: 10,
                    //       spreadRadius: 0.1,
                    //       offset: Offset(0, 10)),
                    // ],
                    color: ThemeColor.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text("Paste direct download link for best working.",
                        style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ThemeColor.white),
                        textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      // boxShadow: const [
                      //   BoxShadow(
                      //       color: ThemeColor.shadow,
                      //       blurRadius: 10,
                      //       spreadRadius: 0.1,
                      //       offset: Offset(0, 10)),
                      // ],

                      // color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: ThemeColor.secondary, width: 0.2)),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: TextField(
                        controller: _fileNameTextController,
                        onChanged: (value) {},
                        showCursor: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: "Enter File Name",
                          // hintStyle:
                          //     GoogleFonts.ubuntu(color: ThemeColor.black),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: width - 90,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: ThemeColor.secondary, width: 0.2),
                        // boxShadow: const [
                        //   BoxShadow(
                        //       color: ThemeColor.shadow,
                        //       blurRadius: 10,
                        //       spreadRadius: 0.1,
                        //       offset: Offset(0, 10)),
                        // ],
                        // color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5),
                          child: TextField(
                            controller: _fileLinkTextController,
                            onChanged: (value) {},
                            showCursor: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              hintText: "Paste File Link",
                              // hintStyle:
                              //     GoogleFonts.ubuntu(color: ThemeColor.black),
                            ),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ClipboardData? cdata =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        String? copiedtext = cdata!.text;
                        _fileLinkTextController.text = copiedtext!;
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.2),
                          // boxShadow: const [
                          //   BoxShadow(
                          //       color: ThemeColor.shadow,
                          //       blurRadius: 10,
                          //       spreadRadius: 0.1,
                          //       offset: Offset(0, 10)),
                          // ],
                          // color: ThemeColor.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.paste_rounded),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (_fileNameTextController.text.isEmpty) {
                      show.snackbar(context, 'Please enter file name');
                    } else if (_fileLinkTextController.text.isEmpty) {
                      show.snackbar(context, 'Please paste file link');
                    } else {
                      dbService.updateVDO(
                          _fileNameTextController.text.replaceAll(' ', ''),
                          "url",
                          _fileLinkTextController.text);
                      show.snackbar(context, 'Video added successfully!');

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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
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
