import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/friends_provider.dart';
import 'package:merhaba_app/widgets/friends/friend_suggestion_card.dart';
import 'package:provider/provider.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocale.friends_label.getString(
              context,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      friendsProvider.setTabIndex(0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: friendsProvider.tabIndex == 0
                            ? Colors.blueGrey.withOpacity(
                                0.25,
                              )
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            fluent.FluentIcons.people,
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocale.friends_label.getString(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      friendsProvider.setTabIndex(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: friendsProvider.tabIndex == 1
                            ? Colors.blueGrey.withOpacity(
                                0.25,
                              )
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            fluent.FluentIcons.questionnaire,
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocale.friend_requests_label.getString(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      friendsProvider.setTabIndex(2);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: friendsProvider.tabIndex == 2
                            ? Colors.blueGrey.withOpacity(
                                0.25,
                              )
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            fluent.FluentIcons.people_add,
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocale.suggestions_label.getString(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (friendsProvider.tabIndex == 0) // friends
              ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [],
              ),
            if (friendsProvider.tabIndex == 1) // friend requests
              ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [],
              ),
            if (friendsProvider.tabIndex == 2) // friend requests
              ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  ...friendsProvider.suggestions.map(
                    (user) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: FriendSuggestionCard(
                        user: user,
                      ),
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
