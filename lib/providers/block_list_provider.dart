import 'package:flutter/material.dart';

class BlockListProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getBlockList() async {
    try {} catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getBlockList();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
