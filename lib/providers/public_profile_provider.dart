import 'package:flutter/material.dart';

class PublicProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _uid = "";
  String get uid => _uid;

  setUID(String value) {
    _uid = value;
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

  Future<void> getUserProfile() async {
    try {} catch (e) {}
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getUserProfile();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
