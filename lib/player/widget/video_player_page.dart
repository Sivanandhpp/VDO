import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/functions/theme_color.dart';
import 'package:vdo/main.dart';
import 'package:vdo/player/other/temp_value.dart';
import 'package:vdo/player/utils/video_player_utils.dart';
import 'package:vdo/player/widget/video_player_bottom.dart';
import 'package:vdo/player/widget/video_player_center.dart';
import 'package:vdo/player/widget/video_player_gestures.dart';
import 'package:vdo/player/widget/video_player_top.dart';
import 'package:vdo/screens/home_screen.dart';
import 'package:vdo/screens/screen_profile.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  Size get _window => MediaQueryData.fromWindow(window).size;
  double get _width => _isFullScreen ? _window.width : _window.width;
  double get _height => _isFullScreen ? _window.height : _window.width * 9 / 16;
  Widget? _playerUI;
  VideoPlayerTop? _top;
  VideoPlayerBottom? _bottom;
  LockIcon? _lockIcon;
  String videoName = 'Video';
  String videoURL = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VideoPlayerUtils.playerHandle(
        'https://drive.google.com/uc?export=download&id=1wP1bPKF85PTWiGkFboj2d95g6aNop5Sa',
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
    // TODO: implement dispose
    VideoPlayerUtils.removeInitializedListener(this);
    VideoPlayerUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
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
                  Container(
                    height: height - 300,
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
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        videoURL = snapshot
                                            .child('url')
                                            .value
                                            .toString();
                                        videoName = snapshot.key.toString();
                                        _changeVideo(videoURL);

                                        setState(() {
                                          _top!.setVideoName(videoName);
                                        });
                                        //   _controller.pause();
                                        //
                                        //   if (snapshot.child("isDownloaded").value.toString() ==
                                        //       "true") {
                                        //     vs.getVideo(fileName);
                                        //     offlineVideo(fileName, videoURL);
                                        //   } else {
                                        //     onlineVideo(videoURL);
                                        //   }

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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                  snapshot
                                                              .child('url')
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
    // _index += 1;
    // if (_index == _urls.length) {
    //   _index = 0;
    // }
  }

  // final List<String> _urls = [
  //   "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
  //   "https://drive.google.com/uc?export=download&id=1kbsRgns2EB4Rkca-L2nMm4C5NjlFqQ2a",
  //   "https://drive.google.com/uc?export=download&id=1MawnFe_JP9f81otDGkmXs3HaVwqYQs_R",
  // ];
  // int _index = 1;
}
