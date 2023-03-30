import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vdo/player/other/temp_value.dart';
import 'package:vdo/player/utils/video_player_utils.dart';

class VideoPlayerGestures extends StatefulWidget {
  const VideoPlayerGestures(
      {Key? key, required this.children, required this.appearCallback})
      : super(key: key);
  final List<Widget> children;
  final Function(bool) appearCallback;
  @override
  _VideoPlayerGesturesState createState() => _VideoPlayerGesturesState();
}

class _VideoPlayerGesturesState extends State<VideoPlayerGestures> {
  bool _appear = true; // Control hide and show
  Timer? _timer;
  double _width = 0.0; // component width
  double _height = 0.0; // component height
  late Offset _startPanOffset; //  The starting position of the slide
  late double _movePan; // Cumulative sum of sliding offsets
  bool _brightnessOk = false; // Whether to allow brightness adjustment
  bool _volumeOk = false; // Whether to allow volume adjustment
  bool _seekOk = false; // Whether to allow seek adjustment
  double _brightnessValue = 0.0; 
  double _volumeValue = 0.0; 
  Duration _positionValue = const Duration(seconds: 0); //  Current playback time, fast forward or rewind by counting gestures
  late PercentageWidget _percentageWidget; // Rewind, fast forward, volume, brightness percentage, widget displayed during gesture operation
  final List<Widget> _children = [];
  @override
  void initState() {
    // TODO: implement initState
    _percentageWidget = PercentageWidget();
    _children.addAll(widget.children);
    _children.add(_percentageWidget);
    super.initState();
    _setInit();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap, 
      onDoubleTap: _onDoubleTap, 
      onVerticalDragStart: _onVerticalDragStart, 
      onVerticalDragUpdate: _onVerticalDragUpdate, 
      onVerticalDragEnd: _onVerticalDragEnd, 
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate, 
      onHorizontalDragEnd: _onHorizontalDragEnd, 
      child: Container(

        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white,
        child: Stack(
          children: _children,
        ),
      ),
    );
  }

  void _setInit() async {
    _volumeValue = await VideoPlayerUtils.getVolume();
    _brightnessValue = await VideoPlayerUtils.getBrightness();
  }

  void _onTap() {
    if (TempValue.isLocked) return;
    _appear = !_appear;
    widget.appearCallback(_appear);
    
    if (_appear == true && VideoPlayerUtils.state == VideoPlayerState.playing) {
      _setupTimer();
    }
  }

  void _onDoubleTap() {
    if (TempValue.isLocked) return;
    VideoPlayerUtils.playerHandle(VideoPlayerUtils.url);
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (TempValue.isLocked) return;
    if (!VideoPlayerUtils.isInitialized) return;
    _resetPan();
    _startPanOffset = details.globalPosition;
    if (_startPanOffset.dx < _width * 0.5) {
     
      _brightnessOk = true;
    } else {
      
      _volumeOk = true;
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (TempValue.isLocked) return;
   
    _movePan += (-details.delta.dy);
    if (_startPanOffset.dx < (_width / 2)) {
      if (_brightnessOk) {
        double b = _getBrightnessValue();
        _percentageWidget
            .percentageCallback("Brightness:${(b * 100).toInt()}%");
        VideoPlayerUtils.setBrightness(b);
      }
    } else {
      if (_volumeOk) {
        double v = _getVolumeValue();
        _percentageWidget.percentageCallback("Volume:${(v * 100).toInt()}%");
        VideoPlayerUtils.setVolume(v);
      }
    }
  }

  void _onVerticalDragEnd(_) {
    if (TempValue.isLocked) return;
    
    _percentageWidget.offstageCallback(true);
    if (_volumeOk) {
      _volumeValue = _getVolumeValue();
      _volumeOk = false;
    } else if (_brightnessOk) {
      _brightnessValue = _getBrightnessValue();
      _brightnessOk = false;
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (TempValue.isLocked) return;
    if (!VideoPlayerUtils.isInitialized) return;
    _resetPan();
    _positionValue = VideoPlayerUtils.position;
    _seekOk = true;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (TempValue.isLocked) return;
    if (!_seekOk) return;
    _movePan += details.delta.dx;
    double value = _getSeekValue();
    String currentSecond = VideoPlayerUtils.formatDuration(
        (value * VideoPlayerUtils.duration.inSeconds).toInt());
    if (_movePan >= 0) {
      _percentageWidget.percentageCallback("Forward:$currentSecond");
    } else {
      _percentageWidget.percentageCallback("Backward:$currentSecond");
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (TempValue.isLocked) return;
    if (!_seekOk) return;
    double value = _getSeekValue();
    int seek = (value * VideoPlayerUtils.duration.inMilliseconds).toInt();
    VideoPlayerUtils.seekTo(position: Duration(milliseconds: seek));
    _percentageWidget.offstageCallback(true);
    _seekOk = false;
  }

 
  double _getBrightnessValue() {
    double value = double.parse(
        (_movePan / _height + _brightnessValue).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }

  // Calculate sound
  double _getVolumeValue() {
    double value =
        double.parse((_movePan / _height + _volumeValue).toStringAsFixed(2));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    return value;
  }

  // Calculate playback progress percentage
  double _getSeekValue() {
    // progress bar percentage control
    double valueHorizontal =
        double.parse((_movePan / _width).toStringAsFixed(2));
    // current progress bar percentage
    double currentValue = _positionValue.inMilliseconds /
        VideoPlayerUtils.duration.inMilliseconds;
    double value =
        double.parse((currentValue + valueHorizontal).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }

  // reset gesture
  void _resetPan() {
    _startPanOffset = const Offset(0, 0);
    _movePan = 0;
    _width = context.size!.width;
    _height = context.size!.height;
  }

  // start timer
  void _setupTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      _appear = false;
      widget.appearCallback(_appear);
      _timer?.cancel();
    });
  }
}

// ignore: must_be_immutable
class PercentageWidget extends StatefulWidget {
  PercentageWidget({Key? key}) : super(key: key);
  late Function(String) percentageCallback; // percentage
  late Function(bool) offstageCallback;
  @override
  _PercentageWidgetState createState() => _PercentageWidgetState();
}

class _PercentageWidgetState extends State<PercentageWidget> {
  String _percentage = ""; // specific percentage information
  bool _offstage = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.percentageCallback = (percentage) {
      _percentage = percentage;
      _offstage = false;
      if (!mounted) return;
      setState(() {});
    };
    widget.offstageCallback = (offstage) {
      _offstage = offstage;
      if (!mounted) return;
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Offstage(
        offstage: _offstage,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(_percentage,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }
}
