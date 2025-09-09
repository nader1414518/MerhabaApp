import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/stories_controller.dart';

class StoriesProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> get stories => _stories;

  final TextEditingController _addStoryTextController = TextEditingController();
  TextEditingController get addStoryTextController => _addStoryTextController;

  String _addStoryPhotoUrl = "";
  String get addStoryPhotoUrl => _addStoryPhotoUrl;

  String _addStoryVideoUrl = "";
  String get addStoryVideoUrl => _addStoryVideoUrl;

  String _addStoryVoiceUrl = "";
  String get addStoryVoiceUrl => _addStoryVoiceUrl;

  int _addStoryDurationInDays = 1;
  int get addStoryDurationInDays => _addStoryDurationInDays;

  Map<String, dynamic> _currentStory = {};
  Map<String, dynamic> get currentStory => _currentStory;

  String _selectedStoryId = "";
  String get selectedStoryId => _selectedStoryId;

  final TextEditingController _editStoryTextController =
      TextEditingController();
  TextEditingController get editStoryTextController => _editStoryTextController;

  String _editStoryPhotoUrl = "";
  String get editStoryPhotoUrl => _editStoryPhotoUrl;

  String _editStoryVideoUrl = "";
  String get editStoryVideoUrl => _editStoryVideoUrl;

  String _editStoryVoiceUrl = "";
  String get editStoryVoiceUrl => _editStoryVoiceUrl;

  int _editStoryDurationInDays = 1;
  int get editStoryDurationInDays => _editStoryDurationInDays;

  setSelectedStoryId(String value) {
    _selectedStoryId = value;
    notifyListeners();
  }

  setCurrentStory(Map<String, dynamic> value) {
    _currentStory = value;
    notifyListeners();
  }

  setAddStoryVoiceUrl(String value) {
    _addStoryVoiceUrl = value;
    notifyListeners();
  }

  setAddStoryVideoUrl(String value) {
    _addStoryVideoUrl = value;
    notifyListeners();
  }

  setAddStoryPhotoUrl(String value) {
    _addStoryPhotoUrl = value;
    notifyListeners();
  }

  setAddStoryDurationInDays(int value) {
    _addStoryDurationInDays = value;
    notifyListeners();
  }

  setEditStoryVoiceUrl(String value) {
    _editStoryVoiceUrl = value;
    notifyListeners();
  }

  setEditStoryVideoUrl(String value) {
    _editStoryVideoUrl = value;
    notifyListeners();
  }

  setEditStoryPhotoUrl(String value) {
    _editStoryPhotoUrl = value;
    notifyListeners();
  }

  setEditStoryDurationInDays(int value) {
    _editStoryDurationInDays = value;
    notifyListeners();
  }

  setStories(List<Map<String, dynamic>> value) {
    _stories = value;
    notifyListeners();
  }

  addToStories(Map<String, dynamic> value) {
    _stories.add(value);
    notifyListeners();
  }

  clearStories() {
    _stories.clear();
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

  bool validateAddFields({bool showMessages = false}) {
    if (addStoryTextController.text == "" &&
        addStoryPhotoUrl == "" &&
        addStoryVideoUrl == "" &&
        addStoryVoiceUrl == "") {
      if (showMessages) {
        Fluttertoast.showToast(msg: "Please fill any of the fields");
      }
      return false;
    }

    return true;
  }

  bool validateEditFields({bool showMessages = false}) {
    if (editStoryTextController.text == "" &&
        editStoryPhotoUrl == "" &&
        editStoryVideoUrl == "" &&
        editStoryVoiceUrl == "") {
      if (showMessages) {
        Fluttertoast.showToast(msg: "Please fill any of the fields");
      }
      return false;
    }

    return true;
  }

  Future<void> addStory() async {
    if (validateAddFields()) {
      var res = await StoriesController.addStory({
        "text": addStoryTextController.text,
        "photo_url": addStoryPhotoUrl,
        "video_url": addStoryVideoUrl,
        "voice_url": addStoryVoiceUrl,
        "duration_days": addStoryDurationInDays,
      });

      if (res["result"] == true) {
        Fluttertoast.showToast(msg: res["message"].toString());

        await getStories();
      } else {
        Fluttertoast.showToast(msg: res["message"].toString());
      }
    }
  }

  Future<void> editStory() async {
    if (validateEditFields()) {
      var res = await StoriesController.updateStory({
        "id": selectedStoryId,
        "text": editStoryTextController.text,
        "photo_url": editStoryPhotoUrl,
        "video_url": editStoryVideoUrl,
        "voice_url": editStoryVoiceUrl,
        "duration_days": editStoryDurationInDays,
      });

      if (res["result"] == true) {
        Fluttertoast.showToast(msg: res["message"].toString());

        await getStories();
      } else {
        Fluttertoast.showToast(msg: res["message"].toString());
      }
    }
  }

  Future<void> deleteStory() async {
    if (selectedStoryId.isNotEmpty) {
      var res = await StoriesController.deleteStory(selectedStoryId);

      if (res["result"] == true) {
        Fluttertoast.showToast(msg: res["message"].toString());

        await getStories();
      } else {
        Fluttertoast.showToast(msg: res["message"].toString());
      }
    }
  }

  Future<void> getStories() async {
    try {
      var res = await StoriesController.getStories();

      setStories(res);
    } catch (e) {
      print(e.toString());
      clearStories();
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getStories();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
