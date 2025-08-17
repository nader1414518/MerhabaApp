import 'package:video_player/video_player.dart';

class VideoCacheManager {
  static final VideoCacheManager _instance = VideoCacheManager._internal();
  factory VideoCacheManager() => _instance;
  VideoCacheManager._internal();

  final Map<String, VideoPlayerController> _controllers = {};
  final Map<String, bool> _initializationStatus = {};

  VideoPlayerController? getController(String url) {
    return _controllers[url];
  }

  bool isInitialized(String url) {
    return _initializationStatus[url] ?? false;
  }

  Future<VideoPlayerController> getOrCreateController(String url) async {
    if (_controllers.containsKey(url)) {
      return _controllers[url]!;
    }

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
      ),
    );

    _controllers[url] = controller;
    _initializationStatus[url] = false;

    try {
      await controller.initialize();
      _initializationStatus[url] = true;
    } catch (e) {
      print('Error initializing video controller for $url: $e');
      _controllers.remove(url);
      _initializationStatus.remove(url);
      rethrow;
    }

    return controller;
  }

  void disposeController(String url) {
    final controller = _controllers[url];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(url);
      _initializationStatus.remove(url);
    }
  }

  void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _initializationStatus.clear();
  }

  void pauseAll() {
    for (final controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  void playOnly(String url) {
    for (final entry in _controllers.entries) {
      if (entry.key == url) {
        if (!entry.value.value.isPlaying) {
          entry.value.play();
        }
      } else {
        if (entry.value.value.isPlaying) {
          entry.value.pause();
        }
      }
    }
  }
}
