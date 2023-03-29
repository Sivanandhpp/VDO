import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/functions/db_service.dart';
import 'package:vdo/functions/theme_color.dart';

import 'package:vdo/functions/video_service.dart';
import 'package:vdo/main.dart';
import 'package:vdo/screens/add_video.dart';
import 'package:vdo/screens/screen_profile.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  //default video
  String videoURL =
      'https://drive.google.com/uc?export=download&id=1wP1bPKF85PTWiGkFboj2d95g6aNop5Sa';
  String fileName = "Wrap";

  VideoService vs = VideoService();
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _controller = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.ubuntu(
                          color: ThemeColor.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        userData.name,
                        style: GoogleFonts.ubuntu(
                          color: ThemeColor.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: CircleAvatar(
                      radius: 28,
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
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            radius: 30,
                            backgroundColor: ThemeColor.white,
                            child: ClipOval(
                              child: Image(
                                height: 50,
                                width: 50,
                                image: AssetImage("assets/avatar.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScreenProfile(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const SizedBox(
                      height: 210,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 40.0,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width - 65,
                      child: VideoProgressIndicator(_controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.navigate_before,
                          ),
                          iconSize: 28.0,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.navigate_next,
                          ),
                          iconSize: 28.0,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.value.volume > 0
                                  ? _controller.setVolume(0)
                                  : _controller.setVolume(50);
                            });
                          },
                          icon: Icon(
                            _controller.value.volume > 0
                                ? Icons.volume_up
                                : Icons.volume_off,
                          ),
                          iconSize: 22.0,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        IconButton(
                          onPressed: () {
                            print("click");
                            vs.download(videoURL, fileName);
                            DatabaseService dbservice = DatabaseService();
                            dbservice.updateVDO(
                                fileName, "isDownloaded", "true");
                          },
                          icon: const Icon(
                            Icons.download,
                          ),
                          iconSize: 28.0,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              height: height - 377,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FirebaseAnimatedList(
                        query: dbReference.child("vdos"),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        defaultChild: const Center(
                          child: LinearProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                        itemBuilder: (context, snapshot, animation, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _controller.pause();
                                  videoURL =
                                      snapshot.child('url').value.toString();
                                  fileName = snapshot.key.toString();
                                  if (snapshot
                                          .child("isDownloaded")
                                          .value
                                          .toString() ==
                                      "true") {
                                    vs.getVideo(fileName);
                                    offlineVideo(fileName);
                                  }
                                  onlineVideo(videoURL);

                                  // setState(() {
                                  //   videoURL = snapshot.value.toString();
                                  // });
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: ThemeColor.shadow,
                                          blurRadius: 10,
                                          spreadRadius: 0.1,
                                          offset: Offset(0, 10)),
                                    ],
                                    color: ThemeColor.offWhite,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.key.toString(),
                                            style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${snapshot.child('url').value.toString().substring(0, 55)}...",
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      snapshot
                                                  .child('isDownloaded')
                                                  .value
                                                  .toString() ==
                                              "true"
                                          ? const Icon(
                                              Icons.download_done_rounded,
                                              color: ThemeColor.black,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColor.primary,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddVideo(),
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  onlineVideo(String link) {
    final controller = VideoPlayerController.network(link);
    _controller = controller;
    setState(() {});
    _controller.initialize().then((_) {
      controller.play();
      setState(() {});
    });
  }

  offlineVideo(String fileName) {
    String filePathString = "/storage/emulated/0/VDO/$fileName.mp4";
    final File filePath = File(filePathString);
    final controller = VideoPlayerController.file(filePath);
    _controller = controller;
    setState(() {});
    _controller.initialize().then((_) {
      controller.play();
      setState(() {});
    });
  }

  Future<bool?> requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      Permission.accessMediaLocation.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
