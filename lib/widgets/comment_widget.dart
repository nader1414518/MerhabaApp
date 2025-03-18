// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:merhaba_app/widgets/text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_localization/flutter_localization.dart';

class CommentWidget extends StatelessWidget {
  Map<String, dynamic> comment = {};

  CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
      jsonDecode(comment["content"]) as Map,
    );

    return Container(
      margin: localization.currentLocale.localeIdentifier == "ar"
          ? EdgeInsets.only(
              left: (MediaQuery.sizeOf(context).width - 60) * 0.35,
            )
          : EdgeInsets.only(
              right: (MediaQuery.sizeOf(context).width - 60) * 0.35,
            ),
      width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15,
        ),
        color: Colors.blueGrey.withOpacity(
          0.25,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: SizedBox(
        width: (MediaQuery.sizeOf(context).width - 60) * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 60) * 0.55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      comment["user_photo"] == ""
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
                              imageUrl: comment["user_photo"],
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
                            width:
                                (MediaQuery.sizeOf(context).width - 60) * 0.2,
                            child: TextWidget(
                              text: comment["username"].toString(),
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
                            width:
                                (MediaQuery.sizeOf(context).width - 60) * 0.2,
                            child: Text(
                              timeago.format(
                                DateTime.parse(
                                    comment["date_added"].toString()),
                                locale: localization
                                            .currentLocale.localeIdentifier ==
                                        'ar'
                                    ? "ar"
                                    : localization.currentLocale
                                                .localeIdentifier ==
                                            'en'
                                        ? 'en_short'
                                        : localization
                                            .currentLocale.localeIdentifier,
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
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (parsedContent["text"] != "")
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 60) * 0.55,
                    child: Text(
                      parsedContent["text"].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 5,
            ),
            if (parsedContent["media"] != "")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      parsedContent["media"]["url"].toString(),
                    ),
                  ),
                ),
                width: 200,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }
}
