import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static SharedPreferences? prefs;

  static Future<SharedPreferences> _getInstance() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!;
  }

  static Future<void> setData(String key, Object data) async {
    final prefs = await _getInstance();
    switch (data.runtimeType) {
      case const (int):
        prefs.setInt(key, data as int);
        break;
      case const (String):
        prefs.setString(key, data as String);
        break;
      case const (bool):
        prefs.setBool(key, data as bool);
        break;
      case const (double):
        prefs.setDouble(key, data as double);
    }
  }

  static Future<void> removeData(String key) async {
    final prefs = await _getInstance();
    prefs.remove(key);
  }

  static Future<int> getInt(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<String> getString(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<bool> getBool(String key) async {
    final prefs = await _getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<double> getDouble(String key) async {
    final prefs = await _getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }
}
