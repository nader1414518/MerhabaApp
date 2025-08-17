import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:merhaba_app/utils/video_cache_manager.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool loop;
  final bool mute;
  final bool showControls;
  final bool showVideoPlayer;
  final bool compactMode; // New parameter for compact controls

  const VideoWidget({
    super.key,
    required this.url,
    this.autoPlay = true,
    this.loop = true,
    this.mute = false,
    this.showControls = true,
    this.showVideoPlayer = true,
    this.compactMode = false, // Default to false for full controls
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isVisible = true;
  bool _showControls = false;
  bool _isMuted = false;
  bool _isPlaying = false;
  final VideoCacheManager _cacheManager = VideoCacheManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isMuted = widget.mute;
    _initializeController();
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only recreate controller if URL changed
    if (oldWidget.url != widget.url) {
      _disposeController();
      _initializeController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _controller?.pause();
    }
  }

  Future<void> _initializeController() async {
    try {
      _controller = await _cacheManager.getOrCreateController(widget.url);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        if (widget.autoPlay && _isVisible) {
          _controller!.play();
          setState(() {
            _isPlaying = true;
          });
        }
        if (widget.loop) {
          _controller!.setLooping(true);
        }
        if (widget.mute) {
          _controller!.setVolume(0.0);
        }
      }
    } catch (error) {
      print('Error initializing video: $error');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  void _disposeController() {
    // Don't dispose the controller here as it's managed by the cache
    _controller = null;
    _isInitialized = false;
  }

  void _togglePlayPause() {
    if (_controller != null) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlaying = false;
        } else {
          _controller!.play();
          _isPlaying = true;
        }
      });
    }
  }

  void _toggleMute() {
    if (_controller != null) {
      setState(() {
        _isMuted = !_isMuted;
        _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      });
    }
  }

  void _showControlsTemporarily() {
    if (!widget.showControls) return;

    setState(() {
      _showControls = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _controller?.value.isPlaying == true) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Don't dispose the controller here as it's managed by the cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_visibility_${widget.url}'),
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0.5;
        if (_isVisible != isVisible) {
          setState(() {
            _isVisible = isVisible;
          });

          if (_controller != null && _isInitialized) {
            if (isVisible) {
              if (widget.autoPlay) {
                _controller!.play();
                setState(() {
                  _isPlaying = true;
                });
              }
            } else {
              _controller!.pause();
              setState(() {
                _isPlaying = false;
              });
            }
          }
        }
      },
      child: GestureDetector(
        onTap: _showControlsTemporarily,
        child: Container(
          child: _controller != null && _isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                    if (widget.showControls)
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: widget.compactMode
                              ? _buildCompactControls()
                              : _buildFullControls(),
                        ),
                      ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Widget _buildCompactControls() {
    return Stack(
      children: [
        // Center play/pause button
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
              onPressed: _togglePlayPause,
            ),
          ),
        ),
        // Top-right mute button
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 20,
            ),
            onPressed: _toggleMute,
          ),
        ),
      ],
    );
  }

  Widget _buildFullControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: _toggleMute,
              ),
            ],
          ),
        ),
        // Center play/pause button
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
            onPressed: _togglePlayPause,
          ),
        ),
        // Bottom controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress bar
              ValueListenableBuilder(
                valueListenable: _controller!,
                builder: (context, VideoPlayerValue value, child) {
                  // Update playing state when controller state changes
                  if (_isPlaying != value.isPlaying) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _isPlaying = value.isPlaying;
                      });
                    });
                  }

                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: value.position.inMilliseconds.toDouble(),
                          max: value.duration.inMilliseconds.toDouble(),
                          onChanged: (newValue) {
                            _controller!.seekTo(
                                Duration(milliseconds: newValue.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(value.position),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(value.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Simple visibility detector widget
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;
  final Key key;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  final GlobalKey _key = GlobalKey();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate visibility fraction
    final topVisible =
        position.dy < screenHeight && position.dy + size.height > 0;
    final bottomVisible =
        position.dy < screenHeight && position.dy + size.height > 0;

    final isVisible = topVisible && bottomVisible;

    if (_isVisible != isVisible) {
      _isVisible = isVisible;
      widget.onVisibilityChanged(VisibilityInfo(
        visibleFraction: isVisible ? 1.0 : 0.0,
        size: size,
        offset: position,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: Container(
        key: _key,
        child: widget.child,
      ),
    );
  }
}

class VisibilityInfo {
  final double visibleFraction;
  final Size size;
  final Offset offset;

  VisibilityInfo({
    required this.visibleFraction,
    required this.size,
    required this.offset,
  });
}
