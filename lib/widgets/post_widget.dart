import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/screens/common/photo_viewer_screen.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatefulWidget {
  Map<String, dynamic> post = {};

  PostWidget({
    super.key,
    required this.post,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;

  String selectedReaction = "like";

  @override
  Widget build(BuildContext context) {
    final timeLineProvider = Provider.of<TimelineProvider>(
      context,
    );

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width - 10,
                // height: 350,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(
                    0.25,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                padding: const EdgeInsets.all(
                  10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 20) * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.post["user_photo"] == ""
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          60,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AssetsUtils.profileAvatar,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.post["user_photo"],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            60,
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
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            65) *
                                        0.4,
                                    child: Text(
                                      widget.post["username"].toString(),
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            65) *
                                        0.4,
                                    child: Text(
                                      timeago.format(
                                        DateTime.parse(widget.post["date_added"]
                                            .toString()),
                                        locale: localization.currentLocale
                                                    .localeIdentifier ==
                                                'ar'
                                            ? "ar"
                                            : localization.currentLocale
                                                        .localeIdentifier ==
                                                    'en'
                                                ? 'en_short'
                                                : localization.currentLocale
                                                    .localeIdentifier,
                                      ),
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 20) * 0.9,
                          child: Text(
                            widget.post["parsedContent"]["text"].toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    widget.post["parsedContent"]["media"].toString() == "" ||
                            widget.post["parsedContent"]["media"].isEmpty
                        ? Container()
                        : Stack(
                            children: [
                              CarouselSlider(
                                items: (widget.post["parsedContent"]["media"]
                                        as List)
                                    .map(
                                      (item) => item["type"] == "photo"
                                          ? CachedNetworkImage(
                                              imageUrl: item["url"].toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PhotoViewerScreen(
                                                      url: item["url"]
                                                          .toString(),
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Icon(Icons.error),
                                              ),
                                            )
                                          : Container(
                                              child: FlickVideoPlayer(
                                                flickManager: FlickManager(
                                                  videoPlayerController:
                                                      VideoPlayerController
                                                          .networkUrl(
                                                    Uri.parse(
                                                      item["url"].toString(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    )
                                    .toList(),
                                carouselController: _controller,
                                options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  aspectRatio: 2.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                  },
                                  viewportFraction: 1.0,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                        0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(
                                      5,
                                    ),
                                    child: Text(
                                      "${(currentIndex + 1)}/${widget.post["parsedContent"]["media"].length}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: Text(
                            timeLineProvider
                                .getAvailableReactions(context)
                                .where((reaction) =>
                                    reaction["value"] == selectedReaction)
                                .first["text"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: ReactionButton<String>(
                            boxColor: Globals.theme == "Light"
                                ? Colors.white
                                : Colors.black,
                            itemSize: const Size(
                              20,
                              20,
                            ),
                            onReactionChanged: (Reaction<String>? reaction) {
                              // debugPrint('Selected value: ${reaction?.value}');
                              if (reaction == null) {
                                return;
                              }

                              if (reaction.value == null) {
                                return;
                              }

                              setState(() {
                                selectedReaction = reaction!.value!;
                              });
                            },
                            reactions: <Reaction<String>>[
                              ...timeLineProvider
                                  .getAvailableReactions(
                                    context,
                                  )
                                  .map(
                                    (reaction) => Reaction<String>(
                                      value: reaction["value"],
                                      icon: reaction["icon"],
                                      title: Text(
                                        reaction["text"],
                                      ),
                                    ),
                                  ),
                            ],
                            selectedReaction: Reaction(
                              value: timeLineProvider
                                  .getAvailableReactions(context)
                                  .where((reaction) =>
                                      reaction["value"] == selectedReaction)
                                  .first["value"],
                              icon: timeLineProvider
                                  .getAvailableReactions(context)
                                  .where((reaction) =>
                                      reaction["value"] == selectedReaction)
                                  .first["icon"],
                              title: Text(
                                timeLineProvider
                                    .getAvailableReactions(context)
                                    .where((reaction) =>
                                        reaction["value"] == selectedReaction)
                                    .first["text"],
                              ),
                            ),
                            // selectedReaction: Reaction<String>(
                            //   value: 'like',
                            //   icon: const Icon(
                            //     fluent.FluentIcons.like,
                            //   ),
                            //   title: Text(
                            //     AppLocale.like_label.getString(
                            //       context,
                            //     ),
                            //   ),
                            // ),
                          ),
                          style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(
                              1,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: Text(
                            AppLocale.comment_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: const Icon(
                            fluent.FluentIcons.comment,
                            size: 15,
                          ),
                          style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(
                              1,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: Text(
                            AppLocale.share_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: const Icon(
                            fluent.FluentIcons.share,
                            size: 15,
                          ),
                          style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(
                              1,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
