import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/friends_provider.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:merhaba_app/providers/public_profile_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:merhaba_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class FriendSuggestionCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const FriendSuggestionCard({
    super.key,
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
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final friendsProvider = Provider.of<FriendsProvider>(
                      context,
                      listen: false,
                    );

                    friendsProvider.addFriend(user["user_id"]);
                  },
                  label: Text(
                    AppLocale.add_friend_label.getString(
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
                    Icons.add_circle_outline,
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
