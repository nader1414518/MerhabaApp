import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';

class ContactSearchProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> get contacts => _contacts;

  addToContacts(Map<String, dynamic> value) {
    _contacts.add(value);
    notifyListeners();
  }

  setContacts(List<Map<String, dynamic>> value) {
    _contacts = value;
    notifyListeners();
  }

  clearContacts() {
    _contacts.clear();
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

  Future<void> searchContacts() async {
    if (_searchController.text.isEmpty) {
      return;
    }

    setIsLoading(true);

    try {
      var res = await SingleChatsController.searchContacts(
        _searchController.text,
      );

      setContacts(res);
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
