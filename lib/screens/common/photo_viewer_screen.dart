import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class PhotoViewerScreen extends StatelessWidget {
  String? url;

  PhotoViewerScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            url!,
          ),
        ),
      ),
    );
  }
}
