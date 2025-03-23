import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getChats() async {}

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getChats();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
