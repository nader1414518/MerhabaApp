import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/posts_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:merhaba_app/providers/stories_provider.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class TimelineProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  final StreamController<SwipeRefreshState> _swipeController =
      StreamController<SwipeRefreshState>.broadcast();
  StreamController get swipeController => _swipeController;

  Stream<SwipeRefreshState> get swipeStream => _swipeController.stream;

  List<Map<String, dynamic>> getAvailableReactions(BuildContext context) {
    return [
      {
        "value": "like",
        "text": AppLocale.like_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/like_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
      {
        "value": "love",
        "text": AppLocale.love_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/love_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
      {
        "value": "wow",
        "text": AppLocale.wow_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/wow_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
      {
        "value": "haha",
        "text": AppLocale.haha_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/haha_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
      {
        "value": "sad",
        "text": AppLocale.sad_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/sad_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
      {
        "value": "angry",
        "text": AppLocale.angry_label.getString(
          context,
        ),
        "icon": Image.asset(
          "assets/images/angry_emoji.png",
          fit: BoxFit.contain,
          width: 20,
          height: 20,
        ),
      },
    ];
  }

  Future<void> onRefresh() async {
    await getPosts();
    final storiesProvider = Provider.of<StoriesProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );
    await storiesProvider.getStories();

    /// When all needed is done change state.
    _swipeController.sink.add(SwipeRefreshState.hidden);
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getPosts() async {
    try {
      var res = await PostsController.getAllPosts();

      _posts = res.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    toggleLoading();

    try {
      await getPosts();
    } catch (e) {
      print(e.toString());
    }

    toggleLoading();
  }
}
