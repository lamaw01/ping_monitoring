import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _pingInterval = 10;
  int get pingInterval => _pingInterval;

  double _uiSize = 150.0;
  double get uiSize => _uiSize;

  late SharedPreferences _prefs;

  Future<void> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    getInterval();
    log('_pingInterval $pingInterval || _uiSize $uiSize');
  }

  int getInterval() {
    return _pingInterval = _prefs.getInt('pingInterval') ?? 10;
  }

  Future<void> updateInterval(int value) async {
    try {
      await _prefs.setInt('pingInterval', value);
      _pingInterval = value;
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  double getUiSize() {
    return _uiSize = _prefs.getDouble('uiSize') ?? 150.0;
  }

  Future<void> updateUiSize(double value) async {
    try {
      await _prefs.setDouble('uiSize', value);
      _uiSize = value;
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
