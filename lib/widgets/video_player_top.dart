import 'package:flutter/material.dart';
import 'package:vdo/core/video_player_utils.dart';
import 'package:vdo/theme/theme_color.dart';

// ignore: must_be_immutable
class VideoPlayerTop extends StatefulWidget {
  // String videoName;
  VideoPlayerTop({Key? key}) : super(key: key);
  late Function(bool) opacityCallback;
  String title = 'AjioFirst';
  bool setVideoName(String videoName) {
    title = videoName;
    return true;
  }

  @override
  _VideoPlayerTopState createState() => _VideoPlayerTopState();
}

class _VideoPlayerTopState extends State<VideoPlayerTop> {
  double _opacity = TempValue.isLocked ? 0.0 : 1.0;
  bool isMuted = false;

  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  void initState() {
    super.initState();
    widget.opacityCallback = (appear) {
      _opacity = appear ? 1.0 : 0.0;
      if (!mounted) return;
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 250),
        child: Container(
          width: double.maxFinite,
          height: 40,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, 0)],
            ),
          ),
          child: Row(
            children: [
              _isFullScreen
                  ? IconButton(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      onPressed: () => VideoPlayerUtils.setPortrait(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(
                      width: 15,
                    ),
              Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  if (isMuted) {
                    VideoPlayerUtils.setVolume(0.5);
                    isMuted = false;
                  } else {
                    VideoPlayerUtils.setVolume(0.0);
                    isMuted = true;
                  }
                  setState(() {});
                },
                icon: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_up,
                  color: ThemeColor.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
