import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';

class NewPostProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentPostMode = "friends";
  String get currentPostMode => _currentPostMode;

  setCurrentPostMode(String value) {
    _currentPostMode = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> getVisibilityOptions(BuildContext context) {
    List<Map<String, dynamic>> list = [
      {
        "label": AppLocale.friends_label.getString(
          context,
        ),
        "value": "friends",
        "icon": const Icon(
          Icons.group,
        ),
      },
      {
        "label": AppLocale.public_label.getString(
          context,
        ),
        "value": "public",
        "icon": const Icon(
          Icons.public,
        ),
      },
      {
        "label": AppLocale.only_me_label.getString(
          context,
        ),
        "value": "only_me",
        "icon": const Icon(
          Icons.remove_red_eye,
        ),
      },
    ];

    return list;
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
