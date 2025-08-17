import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/videos_provider.dart';
import 'package:merhaba_app/utils/video_cache_manager.dart';
import 'package:merhaba_app/widgets/video_widget.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  final controller = Controller();
  final VideoCacheManager _cacheManager = VideoCacheManager();

  @override
  void initState() {
    super.initState();

    controller.addListener((event) {
      print(
          'Scroll event - direction: ${event.direction}, success: ${event.success}');
    });
  }

  @override
  void dispose() {
    // Clean up video cache when leaving the tab
    _cacheManager.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocale.videos_label.getString(
              context,
            ),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .shimmer(duration: 3000.ms, color: const Color(0xFF80DDFF))
              .animate(
                  // onPlay: (controller) => controller.repeat(),
                  ) // this wraps the previous Animate in another Animate
              .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
              .slide(),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.video_call_outlined,
                size: 30,
              ),
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();

                fluent.showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (ctx1) {
                      return fluent.ContentDialog(
                        title: Text(
                          AppLocale.choose_source_label.getString(ctx1),
                        ),
                        actions: [
                          fluent.Button(
                            child: Text(
                              AppLocale.camera_label.getString(ctx1),
                            ),
                            onPressed: () async {
                              Navigator.pop(ctx1);
                              var res = await imagePicker.pickVideo(
                                source: ImageSource.camera,
                              );

                              if (res != null) {
                                Provider.of<VideosProvider>(context,
                                        listen: false)
                                    .uploadReel(
                                  File(
                                    res.path,
                                  ),
                                );
                              }
                            },
                          ),
                          fluent.Button(
                            child: Text(
                              AppLocale.gallery_label.getString(context),
                            ),
                            onPressed: () async {
                              Navigator.pop(ctx1);
                              var res = await imagePicker.pickVideo(
                                source: ImageSource.gallery,
                              );

                              if (res != null) {
                                Provider.of<VideosProvider>(context,
                                        listen: false)
                                    .uploadReel(
                                  File(
                                    res.path,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: Consumer<VideosProvider>(
          builder: (context, videosProvider, child) {
            if (videosProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (videosProvider.reels.isEmpty) {
              return Center(
                child: Text(
                  AppLocale.no_videos_found_label.getString(
                    context,
                  ),
                ),
              );
            }

            return TikTokStyleFullPageScroller(
              contentSize: videosProvider.reels.length,
              swipePositionThreshold: 0.2,
              // ^ the fraction of the screen needed to scroll
              swipeVelocityThreshold: 2000,
              // ^ the velocity threshold for smaller scrolls
              animationDuration: const Duration(milliseconds: 400),
              // ^ how long the animation will take
              controller: controller,
              // ^ registering our own function to listen to page changes
              builder: (BuildContext context, int index) {
                final videoUrl =
                    videosProvider.reels[index]["reel_url"].toString();
                final videoId = videosProvider.reels[index]["id"] ?? index;

                // Preload next video for smooth scrolling
                if (index < videosProvider.reels.length - 1) {
                  final nextUrl =
                      videosProvider.reels[index + 1]["reel_url"].toString();
                  _cacheManager.getOrCreateController(nextUrl);
                }

                return VideoWidget(
                  key: ValueKey('video_$videoId'),
                  url: videoUrl,
                  autoPlay: true, // Let each video autoplay when visible
                );
              },
            );
          },
        ),
      ),
    );
  }
}
