import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/reels_controller.dart';

class VideosProvider with ChangeNotifier {
  List<Map<String, dynamic>> _reels = [];
  List<Map<String, dynamic>> get reels => _reels;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setReels(List<Map<String, dynamic>> value) {
    _reels = value;
    notifyListeners();
  }

  addToReels(Map<String, dynamic> value) {
    _reels.add(value);
    notifyListeners();
  }

  removeFromReels(Map<String, dynamic> value) {
    _reels.remove(value);
    notifyListeners();
  }

  clearReels() {
    _reels = [];
    notifyListeners();
  }

  Future<void> getReels() async {
    try {
      var res = await ReelsController.getReels();

      setReels(res);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadReel(
    File file,
  ) async {
    setIsLoading(true);

    try {
      var res = await ReelsController.uploadReel(
        file,
      );

      if (res["result"] == true) {
        await getReels();
      } else {
        Fluttertoast.showToast(msg: res["message"].toString());
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }

    setIsLoading(false);
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      await getReels();
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
