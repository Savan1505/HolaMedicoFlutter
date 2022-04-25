import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

/// The App's Preferences.
class SharedPref {
  static SharedPreferences? pref;

  static Future<SharedPreferences> getPrefObject() async {
    if (pref == null) pref = await SharedPreferences.getInstance();
    return pref!;
  }

  Future<int> getInt(String key, [int? defValue]) async {
    pref = await getPrefObject();
    return pref!.getInt(key) ?? defValue ?? 0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await getPrefObject();
    return prefs.setInt(key, value);
  }

  Future<double> getDouble(String key, [double? defValue]) async {
    pref = await getPrefObject();
    return pref!.getDouble(key) ?? defValue ?? 0;
  }

  static Future<bool> setDouble(String key, double value) async {
    var prefs = await getPrefObject();
    return prefs.setDouble(key, value);
  }

  Future<String> getString(String key, [String? defValue]) async {
    pref = await getPrefObject();
    return pref!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await getPrefObject();
    return prefs.setString(key, value);
  }

  Future<List<String>> getListData(String key) async {
    pref = await getPrefObject();
    return pref!.getStringList(key) ?? [];
  }

  static Future<bool> setListData(String key, List<String> value) async {
    var prefs = await getPrefObject();
    return prefs.setStringList(key, value);
  }

  /// Removes an entry from persistent storage.
  static Future<bool> remove(String key) async {
    pref = await getPrefObject();
    return pref!.remove(key);
  }

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clear() async {
    pref = await getPrefObject();
    return pref!.clear();
  }

  Future<void> reload() async {
    pref = await getPrefObject();
    pref!.reload();
  }
}
