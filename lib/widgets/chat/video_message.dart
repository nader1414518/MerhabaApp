import 'package:flutter/material.dart';
import 'package:merhaba_app/widgets/video_widget.dart';

class VideoMessage extends StatefulWidget {
  final String url;

  const VideoMessage({
    super.key,
    required this.url,
  });

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: VideoWidget(
          url: widget.url,
          autoPlay: false,
          showControls: true,
          loop: false,
          compactMode: true, // Enable compact mode for chat messages
        ),
      ),
    );
  }
}
