import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';

class NewPostProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentPostMode = "friends";
  String get currentPostMode => _currentPostMode;

  List<Map<String, dynamic>> _media = [];
  List<Map<String, dynamic>> get media => _media;

  int _currentPhotoIndex = 0;
  int get currentPhotoIndex => _currentPhotoIndex;

  Map<String, dynamic> _locationData = {};
  Map<String, dynamic> get locationData => _locationData;

  setLocationData(Map<String, dynamic> value) {
    _locationData = value;
    notifyListeners();
  }

  setCurrentPhotoIndex(int value) {
    _currentPhotoIndex = value;
    notifyListeners();
  }

  addNewMedia(Map<String, dynamic> data) {
    _media.add(data);
    notifyListeners();
  }

  addNewMedias(List<Map<String, dynamic>> data) {
    _media.addAll(data);
    notifyListeners();
  }

  clearMedia() {
    _media.clear();
    notifyListeners();
  }

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
