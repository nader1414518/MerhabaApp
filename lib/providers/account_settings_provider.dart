import 'package:flutter/material.dart';

class AccountSettingsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {} catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
