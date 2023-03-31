import 'dart:io';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:brightness_volume/brightness_volume.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerUtils {
  ///  ---------------------  public -------------------------

  static String get url => _instance._url;
  static VideoPlayerState get state =>
      _instance._state; // current playback state
  static bool get isInitialized =>
      _instance._isInitialized; // Whether the video has been initialized
  static Duration get duration => _instance._duration; // total video duration
  static Duration get position =>
      _instance._position; // Current video playback progress
  static double get aspectRatio =>
      _instance._aspectRatio; // Video playback ratio

  static void pauseAndWait() async{
     await _instance._controller!.pause();
    _instance._updatePlayerState(VideoPlayerState.paused);
    
  }

  // Play, pause, switch video and other playback operations
  static void playerHandle(String url,
      {bool autoPlay = true, bool looping = false}) async {
    if (url == _instance._url) {
      //
      if (_instance._controller!.value.isPlaying) {
        // Playing, click to pause
        await _instance._controller!.pause();
        _instance._updatePlayerState(VideoPlayerState.paused);
      } else {
        // Paused, click to play
        await _instance._controller!.play();
        _instance._updatePlayerState(VideoPlayerState.playing);
      }
    } else {
      if (url.isEmpty) return;

      _instance._resetController();
      if (url.contains("VDO/decrypted")) {
        _instance._controller = VideoPlayerController.file(File(url));
        try {
          await _instance._controller!.initialize();
          _instance._isInitialized = true;
          _instance._url = url;
          _instance._controller!.addListener(_instance._positionListener);
          _instance._duration = _instance._controller!.value.duration;
          _instance._aspectRatio = _instance._controller!.value.aspectRatio;

          _instance._updateInitialize(true);
          if (autoPlay == true) {
            await _instance._controller!.play();
            _instance._updatePlayerState(VideoPlayerState.playing);
          }
          if (looping == true) {
            _instance._controller!.setLooping(looping);
          }
        } catch (_) {
          _instance._initializeError();
        }
      } else {
        _instance._controller = VideoPlayerController.network(url);
        try {
          await _instance._controller!.initialize();
          _instance._isInitialized = true;
          _instance._url = url;
          _instance._controller!.addListener(_instance._positionListener);
          _instance._duration = _instance._controller!.value.duration;
          _instance._aspectRatio = _instance._controller!.value.aspectRatio;

          _instance._updateInitialize(true);
          if (autoPlay == true) {
            await _instance._controller!.play();
            _instance._updatePlayerState(VideoPlayerState.playing);
          }
          if (looping == true) {
            _instance._controller!.setLooping(looping);
          }
        } catch (_) {
          _instance._initializeError();
        }
      }
    }
  }

  static void seekTo({required Duration position}) async {
    if (_instance._controller == null || _instance._url.isEmpty) return;
    _instance._stopPosition = true;
    await _instance._controller!.seekTo(position);
    _instance._stopPosition = false;
  }

  static void initializedListener(
      {required dynamic key, required Function(bool, Widget) listener}) {
    ListenerInitializeModel model =
        ListenerInitializeModel.fromList([key, listener]);
    _instance._initializedPool.add(model);
  }

  static void removeInitializedListener(dynamic key) {
    _instance._initializedPool.removeWhere((element) => element.key == key);
  }

  static void statusListener(
      {required dynamic key, required Function(VideoPlayerState) listener}) {
    ListenerStateModel model = ListenerStateModel.fromList([key, listener]);
    _instance._statusPool.add(model);
  }

  static void removeStatusListener(dynamic key) {
    _instance._statusPool.removeWhere((element) => element.key == key);
  }

  static void positionListener(
      {required dynamic key, required Function(int) listener}) {
    ListenerPositionModel model =
        ListenerPositionModel.fromList([key, listener]);
    _instance._positionPool.add(model);
  }

  static void removePositionListener(dynamic key) {
    _instance._positionPool.removeWhere((element) => element.key == key);
  }

  static Future<double> getVolume() async {
    return await BVUtils.volume;
  }

  static Future<void> setVolume(double volume) async {
    return await BVUtils.setVolume(volume);
  }

  static Future<double> getBrightness() async {
    return await BVUtils.brightness;
  }

  static Future<void> setBrightness(double brightness) async {
    return await BVUtils.setBrightness(brightness);
  }

  static Future<void> setSpeed(double speed) async {
    return _instance._controller!.setPlaybackSpeed(speed);
  }

  static Future<void> setLooping(bool looping) async {
    return _instance._controller!.setLooping(looping);
  }

  static setLandscape() {
    AutoOrientation.landscapeAutoMode();

    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  static setPortrait() {
    AutoOrientation.portraitAutoMode();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }
  }

  static String formatDuration(int second) {
    int min = second ~/ 60;
    int sec = second % 60;
    String minString = min < 10 ? "0$min" : min.toString();
    String secString = sec < 10 ? "0$sec" : sec.toString();
    return "$minString:$secString";
  }

  static dispose() {
    if (_instance._state == VideoPlayerState.playing) {
      _instance._controller?.pause();
    }
    _instance._url = "";
    _instance._statusPool.clear();
    _instance._positionPool.clear();
    _instance._initializedPool.clear();
    _instance._initializedPool.clear();
    TempValue.isLocked = false;
    _instance._state = VideoPlayerState.stopped;
    _instance._isInitialized = false;
    _instance._duration = const Duration(seconds: 0);
    _instance._secondPosition = 0;
    _instance._position = const Duration(seconds: 0);
    _instance._aspectRatio = 1.0;
    _instance._stopPosition = false;
    if (_instance._controller != null) {
      _instance._controller = null;
    }
  }

  ///  ---------------------  private ------------------------

  String _url = "";
  VideoPlayerController? _controller;
  VideoPlayerState _state = VideoPlayerState.stopped;
  bool _isInitialized = false;
  Duration _duration = const Duration(seconds: 0);
  int _secondPosition = 0;
  Duration _position = const Duration(seconds: 0);
  double _aspectRatio = 1.0;
  bool _stopPosition = false;

  static final VideoPlayerUtils _instance = VideoPlayerUtils._internal();
  factory VideoPlayerUtils() => _instance;
  VideoPlayerUtils._internal() {
    _statusPool = [];
    _positionPool = [];
    _initializedPool = [];
  }

  late List<ListenerInitializeModel> _initializedPool;

  late List<ListenerStateModel> _statusPool;

  late List<ListenerPositionModel> _positionPool;

  void _updateInitialize(initialize) {
    _isInitialized = initialize;
    for (var element in _initializedPool) {
      Widget widget = const SizedBox();
      if (initialize == true) {
        widget = AspectRatio(
          aspectRatio: _aspectRatio,
          child: VideoPlayer(_controller!),
        );
      }
      element.listener(initialize, widget);
    }
  }

  // Play listener, here mainly monitor the playback progress
  // Because the playback progress may be updated several times within 1 second, it is a coincidence that the progress status is updated synchronously after the progress update exceeds 1 second
  void _positionListener() {
    if (_stopPosition) return;
    _position = _controller!.value.position;
    int second = _controller!.value.position.inSeconds;
    if (_controller!.value.position == _duration) {
      if (_state != VideoPlayerState.completed) {
        _updatePlayerState(VideoPlayerState.completed);
      }
    }

    if (_secondPosition == second) return;
    _secondPosition = second;
    for (var element in _positionPool) {
      element.listener(second);
    }
  }

  void _updatePlayerState(VideoPlayerState state) {
    _state = state;
    for (var element in _statusPool) {
      element.listener(state);
    }
  }

  void _resetController() {
    if (_controller != null) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      }
      _controller!.removeListener(_instance._positionListener);
      _controller!.dispose();
    }
    _url = "";
    _state = VideoPlayerState.stopped;
    _stopPosition = false;
  }

  void _initializeError() {
    _state = VideoPlayerState.stopped;
    _updateInitialize(false);
  }
}

class ListenerInitializeModel {
  late dynamic key;

  late Function(bool, Widget) listener;

  ListenerInitializeModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}

class ListenerStateModel {
  late dynamic key;

  late Function(VideoPlayerState) listener;

  ListenerStateModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}

class ListenerPositionModel {
  late dynamic key;

  late Function(int) listener;

  ListenerPositionModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}

enum VideoPlayerState {
  stopped, // initial state, stopped or error occurred
  playing, // Now Playing
  paused, // pause
  completed // end of playback
}

class TempValue {
  static bool isLocked = false;
}
