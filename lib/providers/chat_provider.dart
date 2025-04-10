import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _otherUserId = "";
  String get otherUserId => _otherUserId;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  setMessages(List<Map<String, dynamic>> value) {
    _messages = value;
    notifyListeners();
  }

  addToMessages(Map<String, dynamic> value) {
    _messages.add(value);
    notifyListeners();
  }

  clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  setOtherUserId(String value) {
    _otherUserId = value;
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

  Future<void> getChatData() async {
    try {
      // Check if there is already a chat between the current user and the other user, and load the messages if found
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getChatData();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
