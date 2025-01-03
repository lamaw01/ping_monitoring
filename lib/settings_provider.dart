import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _interval = 10;
  int get interval => _interval;

  late SharedPreferences _prefs;

  Future<void> initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    getInterval();
  }

  int getInterval() {
    return _interval = _prefs.getInt('interval') ?? 10;
  }

  Future<void> updateInterval(String value) async {
    final parsedValue = int.tryParse(value) ?? _interval;
    try {
      await _prefs.setInt('interval', parsedValue);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
