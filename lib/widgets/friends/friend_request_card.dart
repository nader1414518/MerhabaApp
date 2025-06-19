import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/friends_provider.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:merhaba_app/providers/public_profile_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:merhaba_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class FriendRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final Map<String, dynamic> user;

  const FriendRequestCard({
    super.key,
    required this.request,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(user);

        final publicProfileProvider = Provider.of<PublicProfileProvider>(
          context,
          listen: false,
        );

        publicProfileProvider.setUID(
          user["user_id"],
        );

        publicProfileProvider.getData();

        Navigator.of(context, rootNavigator: true).pushNamed(
          "/public_profile",
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(
            0.25,
          ),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                user["photo_url"] == "" || user["photo_url"] == null
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
                        imageUrl: user["photo_url"],
                        imageBuilder: (context, imageProvider) => Container(
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
                      width: (MediaQuery.sizeOf(context).width - 65) * 0.6,
                      child: TextWidget(
                        text: user["full_name"].toString(),
                        // textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 65) * 0.2,
                  child: Text(
                    timeago.format(
                      DateTime.parse(request["date_added"].toString()),
                      locale: localization.currentLocale.localeIdentifier ==
                              'ar'
                          ? "ar"
                          : localization.currentLocale.localeIdentifier == 'en'
                              ? 'en_short'
                              : localization.currentLocale.localeIdentifier,
                    ),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final friendsProvider = Provider.of<FriendsProvider>(
                      context,
                      listen: false,
                    );

                    friendsProvider.acceptFriendRequest(request["id"]);
                  },
                  label: Text(
                    AppLocale.confirm_label.getString(
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx1) => fluent.ContentDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocale.delete_friend_request_label.getString(
                                context,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(ctx1);

                                    final friendsProvider =
                                        Provider.of<FriendsProvider>(
                                      context,
                                      listen: false,
                                    );

                                    friendsProvider
                                        .deleteFriendRequest(request["id"]);
                                  },
                                  label: Text(
                                    AppLocale.delete_label.getString(
                                      ctx1,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(ctx1);
                                  },
                                  label: Text(
                                    AppLocale.cancel_label.getString(
                                      ctx1,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  label: Text(
                    AppLocale.delete_label.getString(
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
