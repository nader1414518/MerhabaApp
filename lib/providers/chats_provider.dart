import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';

class ChatsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> get chats => _chats;

  setChats(List<Map<String, dynamic>> value) {
    _chats = value;
    notifyListeners();
  }

  addToChats(Map<String, dynamic> value) {
    _chats.add(value);
    notifyListeners();
  }

  clearChats() {
    _chats.clear();
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

  Future<void> getChats() async {
    try {
      var res = await SingleChatsController.getMyChats();

      print(res.length);

      setChats(res);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      clearChats();

      await getChats();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
