import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/chats_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/providers/stories_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/widgets/post_widget.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import '';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeLineProvider = Provider.of<TimelineProvider>(
      context,
    );

    final profileTabProvider = Provider.of<ProfileTabProvider>(
      context,
      listen: false,
    );

    final storiesProvider = Provider.of<StoriesProvider>(
      context,
      listen: false,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
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
              .slide(),
          actions: [
            IconButton(
              onPressed: () {
                final chatsProvider = Provider.of<ChatsProvider>(
                  context,
                  listen: false,
                );

                chatsProvider.getData();

                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  "/chats",
                );
              },
              icon: const Icon(
                CupertinoIcons.bubble_left_bubble_right,
              ),
            ),
          ],
        ),
        body: SwipeRefresh.adaptive(
          stateStream: timeLineProvider.swipeStream,
          onRefresh: timeLineProvider.onRefresh,
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            ListView(
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
                              width:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.6,
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
                const SizedBox(
                  height: 10,
                ),
                // Stories
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      InkWell(
                        child: Stack(
                          children: [
                            profileTabProvider.photoUrl == ""
                                ? Container(
                                    // height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          AssetsUtils.profileAvatar,
                                        ),
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: profileTabProvider.photoUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      // height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                color: Colors.black.withOpacity(0.5),
                                width: 120,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(
                            "/new_story",
                          );
                        },
                      ),
                      ...storiesProvider.stories.map((story) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 1,
                  color: const Color(0x8080DDFF),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                ).animate().scale(
                      duration: 1200.ms,
                      alignment: Alignment.centerLeft,
                    ),
                ...timeLineProvider.posts.map((post) {
                  post["parsedContent"] = Map<String, dynamic>.from(
                    jsonDecode(post["content"]) as Map,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.1,
                    ),
                    child: PostWidget(
                      post: post,
                    ),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
