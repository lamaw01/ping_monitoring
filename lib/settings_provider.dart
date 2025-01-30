import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _pingInterval = 10;
  int get pingInterval => _pingInterval;

  double _uiSize = 150.0;
  double get uiSize => _uiSize;

  // late Timer timer;

  // void initTimer(AsyncCallback callBack) {
  //   timer = Timer.periodic(Duration(seconds: _pingInterval), (Timer _) async {
  //     callBack();
  //   });
  // }

  void showSettings() {
    log('_pingInterval $pingInterval || _uiSize $uiSize');
  }

  Future<void> initSettings() async {
    await getInterval();
    await getUiSize();
  }

  Future<int> getInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return _pingInterval = prefs.getInt('pingInterval') ?? 10;
  }

  Future<void> updateInterval(int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pingInterval', value);
      _pingInterval = value;
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<double> getUiSize() async {
    final prefs = await SharedPreferences.getInstance();
    return _uiSize = prefs.getDouble('uiSize') ?? 150.0;
  }

  Future<void> updateUiSize(double value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('uiSize', value);
      _uiSize = value;
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
