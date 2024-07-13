import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

//! Here The Initialize of shared prefernece.
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

//! this method to set data
  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    } else if (value is double) {
      return await _sharedPreferences.setDouble(key, value);
    } else {
      return await _sharedPreferences.setStringList(key, value);
    }
  }

//! this method to get data
  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  //! this method to get (list of string) data
  static List<String> getStringList({required String key}) {
    return _sharedPreferences.getStringList(key) ?? [];
  }

//! remove specific data using key
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

//! this method to check if shared preference contains {key}
  static Future<bool> containsKey({required String key}) async {
    return _sharedPreferences.containsKey(key);
  }

//! remove all data
  static Future<bool> clearData({required String key}) async {
    return _sharedPreferences.clear();
  }
}
