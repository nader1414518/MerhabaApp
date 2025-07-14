import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/friends_provider.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/public_profile_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final publicProfileProvider = Provider.of<PublicProfileProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocale.user_profile_label.getString(
                context,
              ),
            ),
          ),
          body: publicProfileProvider.isLoading
              ? const Center(
                  child: fluent.ProgressBar(),
                )
              : publicProfileProvider.currentProfile.isEmpty
                  ? Center(
                      child: Text(
                        AppLocale.no_data_found_label.getString(
                          context,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      children: [
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  publicProfileProvider.currentProfile[
                                                  "photo_url"] !=
                                              "" &&
                                          publicProfileProvider.currentProfile[
                                                  "photo_url"] !=
                                              null
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            publicProfileProvider
                                                .currentProfile["photo_url"],
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                            AssetsUtils.profileAvatar,
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                publicProfileProvider
                                    .currentProfile["full_name"]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                publicProfileProvider.currentProfile["email"]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              if (publicProfileProvider
                                          .currentProfile["phone"] !=
                                      "" &&
                                  publicProfileProvider
                                          .currentProfile["phone"] !=
                                      null)
                                Text(
                                  publicProfileProvider.currentProfile["phone"]
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // TODO: Share profile
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(
                                0.25,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocale.share_label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.share,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            // print(publicProfileProvider.currentProfile);
                            if (publicProfileProvider.isFriend) {
                              // TODO: Remove friend
                              showDialog(
                                context: context,
                                builder: (ctx1) => AlertDialog(
                                  title: Text(
                                    AppLocale.unfriend_label.getString(context),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        final friendsProvider =
                                            Provider.of<FriendsProvider>(
                                          context,
                                          listen: false,
                                        );

                                        friendsProvider.unFriend(
                                          publicProfileProvider
                                              .currentProfile["user_id"],
                                        );

                                        Navigator.of(ctx1).pop();

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocale.unfriend_label.getString(
                                          ctx1,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(ctx1).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocale.cancel_label.getString(
                                          ctx1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // TODO: Add friend
                              final friendsProvider =
                                  Provider.of<FriendsProvider>(
                                context,
                                listen: false,
                              );

                              friendsProvider.addFriend(
                                publicProfileProvider.currentProfile["user_id"],
                              );

                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(
                                0.25,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  publicProfileProvider.isFriend
                                      ? AppLocale.remove_friend_label.getString(
                                          context,
                                        )
                                      : AppLocale.add_friend_label.getString(
                                          context,
                                        ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  publicProfileProvider.isFriend
                                      ? Icons.remove_circle_outline
                                      : Icons.add_circle_outline,
                                  size: 15,
                                  color: publicProfileProvider.isFriend
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx1) => AlertDialog(
                                title: Text(
                                  AppLocale.block_label.getString(
                                    context,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx1).pop();

                                      final friendsProvider =
                                          Provider.of<FriendsProvider>(
                                        context,
                                        listen: false,
                                      );

                                      friendsProvider.blockUser(
                                        publicProfileProvider
                                            .currentProfile["user_id"],
                                      );

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocale.confirm_label.getString(
                                        ctx1,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx1).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocale.cancel_label.getString(
                                        ctx1,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.destructiveRed.withOpacity(
                                0.75,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocale.block_label.getString(
                                    context,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.block,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
