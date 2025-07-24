import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/friends_controller.dart';

class BlockListProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _blockList = [];
  List<Map<String, dynamic>> get blockList => _blockList;

  setBlockList(List<Map<String, dynamic>> value) {
    _blockList = value;
    notifyListeners();
  }

  addToBlockList(Map<String, dynamic> value) {
    _blockList.add(value);
    notifyListeners();
  }

  clearBlockList() {
    _blockList.clear();
    notifyListeners();
  }

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getBlockList() async {
    try {
      var res = await FriendsController.getBlockList();

      setBlockList(res);
    } catch (e) {
      print(e.toString());
      clearBlockList();
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
