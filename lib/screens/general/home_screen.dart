import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/home_screen_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/screens/tabs/friends/friends_tab.dart';
import 'package:merhaba_app/screens/tabs/home/home_tab.dart';
import 'package:merhaba_app/screens/tabs/notifications/notifications_tab.dart';
import 'package:merhaba_app/screens/tabs/profile/profile_tab.dart';
import 'package:merhaba_app/screens/tabs/videos/videos_tab.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  PersistentTabController _controller = PersistentTabController();

  @override
  Widget build(BuildContext context) {
    final homeScreenProvider = Provider.of<HomeScreenProvider>(context);

    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: localization.currentLocale.localeIdentifier == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: [
            HomeTab(),
            FriendsTab(),
            VideosTab(),
            NotificationsTab(),
            ProfileTab(),
          ],
          onItemSelected: (value) {
            // print(value);
            if (value == 0) {
              final timeLineProvider = Provider.of<TimelineProvider>(
                context,
                listen: false,
              );

              timeLineProvider.getData();
            }

            if (value == 4) {
              final profileTabProvider = Provider.of<ProfileTabProvider>(
                context,
                listen: false,
              );

              profileTabProvider.getData();
            }
          },
          items: [
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.home),
              // title: ("Home"),
              title: AppLocale.home_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: Globals.theme == "Dark"
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.group),
              // title: ("Friends"),
              title: AppLocale.friends_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: Globals.theme == "Dark"
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.video_camera_solid),
              // title: ("Videos"),
              title: AppLocale.videos_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: Globals.theme == "Dark"
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.notifications),
              // title: ("Notifications"),
              title: AppLocale.notifications_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: Globals.theme == "Dark"
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.account_circle_sharp),
              // title: ("Profile"),
              title: AppLocale.profile_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: Globals.theme == "Dark"
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
            ),
          ],
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
          padding: const EdgeInsets.only(top: 8),
          backgroundColor:
              Globals.theme == "Dark" ? Colors.grey.shade900 : Colors.blueGrey,
          isVisible: homeScreenProvider.isVisible,
          // animationSettings: const NavBarAnimationSettings(
          //   navBarItemAnimation: ItemAnimationSettings(
          //     // Navigation Bar's items animation properties.
          //     duration: Duration(milliseconds: 100),
          //     curve: Curves.ease,
          //   ),
          //   screenTransitionAnimation: ScreenTransitionAnimationSettings(
          //     // Screen transition animation on change of selected tab.
          //     animateTabTransition: true,
          //     duration: Duration(milliseconds: 100),
          //     screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          //   ),
          // ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle: NavBarStyle
              .style14, // Choose the nav bar style with this property
        ),
      ),
    );
  }
}
