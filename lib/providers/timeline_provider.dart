import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/posts_controller.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class TimelineProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  final StreamController<SwipeRefreshState> _swipeController =
      StreamController<SwipeRefreshState>.broadcast();
  StreamController get swipeController => _swipeController;

  Stream<SwipeRefreshState> get swipeStream => _swipeController.stream;

  Future<void> onRefresh() async {
    await getPosts();

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

      _posts = res;
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
