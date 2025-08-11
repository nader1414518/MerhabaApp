import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';

class VideosTab extends StatelessWidget {
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

                              if (res != null) {}
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

                              if (res != null) {}
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
