import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  String _selectedPage = "Dashboard";

  String get selectedPage => _selectedPage;

  void changePage(String page) {
    _selectedPage = page;
    notifyListeners();
  }
}