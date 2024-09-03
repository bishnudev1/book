import 'dart:developer';

import 'package:flutter/material.dart';

class HelperServices with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeCurrentIndex({required int value}) {
    _currentIndex = value;
    notifyListeners();
    log("_currentIndex: ${_currentIndex}");
  }
}
