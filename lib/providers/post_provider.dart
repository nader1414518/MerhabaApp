import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/comments_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';

class PostProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _currentPost = {};
  Map<String, dynamic> get currentPost => _currentPost;

  final TextEditingController _newCommentController = TextEditingController();
  TextEditingController get newCommentController => _newCommentController;

  final FocusNode _newCommentFocusNode = FocusNode();
  FocusNode get newCommentFocusNode => _newCommentFocusNode;

  bool _isNewCommentEmpty = true;
  bool get isNewCommentEmpty => _isNewCommentEmpty;

  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> get comments => _comments;

  setComments(List<Map<String, dynamic>> value) {
    _comments = value;
    notifyListeners();
  }

  addToComments(Map<String, dynamic> value) {
    _comments.add(value);
    notifyListeners();
  }

  clearComments() {
    _comments.clear();
    notifyListeners();
  }

  setIsNewCommentEmpty(bool value) {
    _isNewCommentEmpty = value;
    notifyListeners();
  }

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

  Future<void> onAdd(BuildContext context) async {
    try {
      var text = newCommentController.text;

      Map<String, dynamic> content = {
        "text": text,
        "media": "",
      };

      _newCommentController.clear();
      _isNewCommentEmpty = true;
      notifyListeners();

      var res = await CommentsController.addComment({
        "content": jsonEncode(content),
        "post_id": _currentPost["id"],
      });

      if (res["result"] == true) {
        Fluttertoast.showToast(
          msg: AppLocale.posted_successfully_label.getString(
            context,
          ),
        );

        getComments();

        // TODO: send notification to post owner for the comment
      } else {
        Fluttertoast.showToast(
          msg: AppLocale.something_went_wrong_label.getString(
            context,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getComments() async {
    try {
      var res = await CommentsController.getCommentsForPost(
        _currentPost["id"],
      );

      setComments(res);
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
