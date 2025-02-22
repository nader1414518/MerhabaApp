import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeLineProvider = Provider.of<TimelineProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: const Text(
              // AppLocale.home_label.getString(
              //   context,
              // ),
              "MERHABA",
              style: TextStyle(
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
                .slide()),
        body: ListView(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  color: Colors.grey.withOpacity(
                    0.05,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 60) * 0.6,
                          child: Text(
                            AppLocale.whats_on_your_mind_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.photo,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              onTap: () async {
                // Go to post screen
                final profileTabProvider = Provider.of<ProfileTabProvider>(
                  context,
                  listen: false,
                );

                await profileTabProvider.getData();

                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed("/new_post");
              },
            ),
            Container(
              height: 2,
              color: const Color(0x8080DDFF),
              margin: const EdgeInsets.symmetric(vertical: 5),
            ).animate().scale(
                  duration: 1200.ms,
                  alignment: Alignment.centerLeft,
                ),
            ...timeLineProvider.posts.map((post) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: PostWidget(
                  post: post,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
