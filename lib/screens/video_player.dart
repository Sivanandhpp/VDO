import 'dart:math';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdo/main.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  String videoURL =
      'https://drive.google.com/uc?export=download&id=1wP1bPKF85PTWiGkFboj2d95g6aNop5Sa';
  var _progress = 0.0;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                      ],
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FirebaseAnimatedList(
                query: dbReference.child("vdos"),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                sort: (b, a) {
                  return a.key.toString().compareTo(b.key.toString());
                },
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
                          onVdoLinkChange(snapshot.value.toString());

                          // setState(() {
                          //   videoURL = snapshot.value.toString();
                          // });
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // imgOrPdf(snapshot),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // titleWithDel(snapshot),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      snapshot.key.toString(),
                                      style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.value.toString().substring(0, 60) + "..."}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  onVdoLinkChange(String link) {
    final controller = VideoPlayerController.network(link);
    _controller = controller;
    setState(() {});
    _controller.initialize().then((_) {
      controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
