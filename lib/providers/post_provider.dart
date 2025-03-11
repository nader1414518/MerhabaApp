import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _currentPost = {};
  Map<String, dynamic> get currentPost => _currentPost;

  final TextEditingController _newCommentController = TextEditingController();
  TextEditingController get newCommentController => _newCommentController;

  final FocusNode _newCommentFocusNode = FocusNode();
  FocusNode get newCommentFocusNode => _newCommentFocusNode;

  setCurrentPost(Map<String, dynamic> value) {
    _currentPost = value;
    notifyListeners();
  }

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getComments() async {
    try {
      // TODO: get comments here
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    toggleLoading();

    try {
      await getComments();
    } catch (e) {
      print(e.toString());
    }

    toggleLoading();
  }
}
