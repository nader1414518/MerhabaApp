import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';
import 'package:merhaba_app/controllers/users_controller.dart';
import 'package:merhaba_app/main.dart';

class ChatProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _otherUserId = "";
  String get otherUserId => _otherUserId;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  int _chatId = -1;
  int get chatId => _chatId;

  Map<String, dynamic> _chatData = {};
  Map<String, dynamic> get chatData => _chatData;

  Map<String, dynamic> _otherUserData = {};
  Map<String, dynamic> get otherUserData => _otherUserData;

  bool _isInputEmpty = true;
  bool get isInputEmpty => _isInputEmpty;

  bool _isVoiceRecorderOpen = false;
  bool get isVoiceRecorderOpen => _isVoiceRecorderOpen;

  bool _isVoiceRecorderRecording = false;
  bool get isVoiceRecorderRecording => _isVoiceRecorderRecording;

  setOtherUserData(Map<String, dynamic> value) {
    _otherUserData = value;
    notifyListeners();
  }

  setIsVoiceRecorderRecording(bool value) {
    _isVoiceRecorderRecording = value;
    notifyListeners();
  }

  setIsVoiceRecorderOpen(bool value) {
    _isVoiceRecorderOpen = value;
    notifyListeners();
  }

  toggleVoiceRecorderOpen() {
    _isVoiceRecorderOpen = !_isVoiceRecorderOpen;
    notifyListeners();
  }

  setIsInputEmpty(bool value) {
    _isInputEmpty = value;
    notifyListeners();
  }

  setChatData(Map<String, dynamic> value) async {
    _chatData = value;
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      if (_chatData["user1_id"] == uid) {
        _otherUserId = _chatData["user2_id"];
      } else {
        _otherUserId = _chatData["user1_id"];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  setChatId(int value) {
    _chatId = value;
    notifyListeners();
  }

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

  Future<void> onSendMessage(
    BuildContext context,
    String text,
  ) async {
    try {
      if (messages.isEmpty) {
        var startRes = await SingleChatsController.startChat({
          "user_id": otherUserId,
          "message": text,
        });

        if (startRes["result"] == true) {
          var id = num.parse(startRes["chatId"].toString()).toInt();

          setChatId(id);

          getChatData();
        }
      } else {
        await SingleChatsController.onSendMessage({
          "chatId": chatId,
          "message": text,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getChatData() async {
    try {
      var res = await SingleChatsController.getChatData(chatId);
      if (res["result"] == true) {
        setChatData(
          Map<String, dynamic>.from(
            res["data"] as Map,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getOtherUserData() async {
    try {
      // print(otherUserId);
      var res = await UsersController.getUserData(otherUserId);

      if (res["result"] == true) {
        // print(res["data"]);
        setOtherUserData(res["data"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      // setChatId(-1);
      setChatData({});
      clearMessages();

      await getChatData();
      await getOtherUserData();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
