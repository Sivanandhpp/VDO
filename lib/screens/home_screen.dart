import 'dart:ui';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/core/db_service.dart';
import 'package:vdo/widgets/snackbar_widget.dart';
import 'package:vdo/theme/theme_color.dart';
import 'package:vdo/core/video_service.dart';
import 'package:vdo/main.dart';
import 'package:vdo/core/video_player_utils.dart';
import 'package:vdo/widgets/video_player_bottom.dart';
import 'package:vdo/widgets/video_player_center.dart';
import 'package:vdo/widgets/video_player_gestures.dart';
import 'package:vdo/widgets/video_player_top.dart';
import 'package:vdo/screens/add_video.dart';
import 'package:vdo/screens/screen_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseService dbservice = DatabaseService();
  ShowSnackbar show = ShowSnackbar();
  VideoService vs = VideoService();
  late String directory;
  List file = [];
  List<String> fileList = [];
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  Size get _window => MediaQueryData.fromWindow(window).size;
  double get _width => _isFullScreen ? _window.width : _window.width;
  double get _height => _isFullScreen ? _window.height : _window.width * 9 / 16;
  Widget? _playerUI;
  VideoPlayerTop? _top;
  VideoPlayerBottom? _bottom;
  LockIcon? _lockIcon;
  String videoName = 'AjioFirst';
  String videoURL = '';
  int currentVideoIndex = 0;
  Map<int, Map<String, String>> itemMap = {};
  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("/storage/emulated/0/VDO/encrypted").listSync();
      for (int i = 0; i < file.length; i++) {
        String s = file[i].toString();
        fileList.add(s.substring(0, s.indexOf('.')).split('/').last);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listofFiles();

    dbReference.child("users").once().then((value) => null);
    VideoPlayerUtils.playerHandle(
        'https://manusebastian.com/assets/img/content/ajio/ajiofirst.mp4',
        autoPlay: false);

    VideoPlayerUtils.initializedListener(
        key: this,
        listener: (initialize, widget) {
          if (initialize) {
            _top ??= VideoPlayerTop();
            _lockIcon ??= LockIcon(
              lockCallback: () {
                _top!.opacityCallback(!TempValue.isLocked);
                _bottom!.opacityCallback(!TempValue.isLocked);
              },
            );
            _bottom ??= VideoPlayerBottom();
            _playerUI = widget;
            if (!mounted) return;
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    VideoPlayerUtils.removeInitializedListener(this);
    VideoPlayerUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: _isFullScreen
            ? safeAreaPlayerUI()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ,
                            //     ));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 0, right: 10, top: 10, bottom: 10),
                            child: const Icon(
                              Icons.menu,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          "Video Player",
                          style: GoogleFonts.ubuntu(
                            color: ThemeColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          child: CircleAvatar(
                            radius: 20,
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
                  safeAreaPlayerUI(),
                  SizedBox(
                    height: height - 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ThemeColor.primary,
                                border: Border.all(
                                    color: ThemeColor.primary, width: 0.1)),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                currentVideoIndex == 0
                                    ? Container(
                                        width: 40,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          currentVideoIndex -= 1;

                                          String tempVidName =
                                              itemMap[currentVideoIndex]!
                                                  .keys
                                                  .toString();

                                          String tempVidLink =
                                              itemMap[currentVideoIndex]!
                                                  .values
                                                  .toString();

                                          setState(() {
                                            videoName = tempVidName.substring(
                                                1, tempVidName.length - 1);
                                            videoURL = tempVidLink.substring(
                                                1, tempVidLink.length - 1);
                                            _top?.setVideoName(videoName);
                                          });
                                          _offlineOrOnline(videoName, videoURL);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: ThemeColor.white,
                                        )),
                                fileList.contains(videoName)
                                    ? GestureDetector(
                                        onTap: () {
                                          show.snackbar(context,
                                              'Video already downloaded');

                                          vs
                                              .download(videoURL, videoName)
                                              .then((value) {
                                            setState(() {
                                              _listofFiles();
                                            });
                                          });

                                          dbservice.updateVDO(videoName,
                                              "isDownloaded", "true");
                                        },
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Offline",
                                              style: TextStyle(
                                                  color: ThemeColor.white,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.download_done_rounded,
                                              color: ThemeColor.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          show.snackbar(context,
                                              'Downloading video: $videoName...');

                                          vs
                                              .download(videoURL, videoName)
                                              .then((value) {
                                            setState(() {
                                              _listofFiles();
                                            });
                                          });

                                          dbservice.updateVDO(videoName,
                                              "isDownloaded", "true");
                                        },
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Download",
                                              style: TextStyle(
                                                  color: ThemeColor.white,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.download_rounded,
                                              color: ThemeColor.white,
                                              size: 20,
                                            ),
                                          ],
                                        )),
                                currentVideoIndex == itemMap.length - 1
                                    ? Container(
                                        width: 40,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          currentVideoIndex += 1;

                                          String tempVidName =
                                              itemMap[currentVideoIndex]!
                                                  .keys
                                                  .toString();

                                          String tempVidLink =
                                              itemMap[currentVideoIndex]!
                                                  .values
                                                  .toString();
                                          setState(() {
                                            videoName = tempVidName.substring(
                                                1, tempVidName.length - 1);
                                            videoURL = tempVidLink.substring(
                                                1, tempVidLink.length - 1);
                                            _top?.setVideoName(videoName);
                                          });
                                          _offlineOrOnline(videoName, videoURL);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: ThemeColor.white,
                                        ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FirebaseAnimatedList(
                              query: dbReference.child("vdos"),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              defaultChild: const Center(
                                child: LinearProgressIndicator(
                                  color: ThemeColor.primary,
                                ),
                              ),
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                itemMap[index] = {
                                  snapshot.key.toString():
                                      snapshot.child("url").value.toString()
                                };
                                return Column(
                                  children: [
                                    snapshot.key.toString() == videoName
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              currentVideoIndex = index;
                                              videoName =
                                                  snapshot.key.toString();
                                              videoURL = snapshot
                                                  .child('url')
                                                  .value
                                                  .toString();
                                              _offlineOrOnline(
                                                  videoName, videoURL);
                                              setState(() {
                                                _top?.setVideoName(videoName);
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: ThemeColor.offWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: ThemeColor.primary,
                                                      width: 0.1)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        snapshot.key.toString(),
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        snapshot
                                                                    .child(
                                                                        'url')
                                                                    .value
                                                                    .toString()
                                                                    .length >
                                                                55
                                                            ? "${snapshot.child('url').value.toString().substring(0, 55)}..."
                                                            : snapshot
                                                                .child('url')
                                                                .value
                                                                .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  fileList.contains(snapshot.key
                                                          .toString())
                                                      ? IconButton(
                                                          onPressed: () {
                                                            show.snackbar(
                                                                context,
                                                                'Video already downloaded');
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .download_done_rounded,
                                                            color: ThemeColor
                                                                .black,
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            show.snackbar(
                                                                context,
                                                                'Downloading video: ${snapshot.key.toString()}...');

                                                            vs
                                                                .download(
                                                                    snapshot
                                                                        .child(
                                                                            'url')
                                                                        .value
                                                                        .toString(),
                                                                    snapshot.key
                                                                        .toString())
                                                                .then((value) {
                                                              setState(() {
                                                                _listofFiles();
                                                              });
                                                            });

                                                            dbservice.updateVDO(
                                                                snapshot.key
                                                                    .toString(),
                                                                "isDownloaded",
                                                                "true");
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .download_rounded,
                                                            color: ThemeColor
                                                                .black,
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddVideo(),
              ));
        },
        label: const Text(
          'Add Video',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        // icon: const Icon(Icons.add),
        backgroundColor: ThemeColor.primary,
      ),
    );
  }

  Widget safeAreaPlayerUI() {
    return SafeArea(
      top: !_isFullScreen,
      bottom: !_isFullScreen,
      left: !_isFullScreen,
      right: !_isFullScreen,
      child: SizedBox(
          height: _height,
          width: _width,
          child: _playerUI != null
              ? VideoPlayerGestures(
                  appearCallback: (appear) {
                    _top!.opacityCallback(appear);
                    _lockIcon!.opacityCallback(appear);
                    _bottom!.opacityCallback(appear);
                  },
                  children: [
                    Center(
                      child: _playerUI,
                    ),
                    _top!,
                    _lockIcon!,
                    _bottom!
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )),
    );
  }

  void _changeVideo(String url) {
    _playerUI = null;
    setState(() {});
    VideoPlayerUtils.playerHandle(url);
  }

  void _offlineOrOnline(String videoName, String videoURL) {
    VideoPlayerUtils.pauseAndWait();
    if (fileList.contains(videoName)) {
      show.snackbar(context, 'Loading video: $videoName from storage...');
      vs.getVideo(videoName).then((value) {
        _changeVideo("/storage/emulated/0/VDO/decrypted/$videoName.mp4");
      });
    } else {
      show.snackbar(context, 'Loading video: $videoName from network...');
      _changeVideo(videoURL);
    }
  }
}
