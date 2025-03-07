import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isDarkMode = false;
  String language = 'fr'; // 'fr', 'en', 'ar'

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    language = lang;
    notifyListeners();
  }
}