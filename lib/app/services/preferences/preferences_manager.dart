import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  SharedPreferences? _sharedPrefs;
  PrefManager._();

  static final PrefManager instance = PrefManager._();

  Future<SharedPreferences> get preference async {
    if (_sharedPrefs != null) {
      return _sharedPrefs!;
    } else {
      _sharedPrefs = await SharedPreferences.getInstance();
      return _sharedPrefs!;
    }
  }

  setStr(String key, String value) async {
    var pref = await instance.preference;
    pref.setString(key, value);
  }

  Future<bool> exist(String key) async {
    var pref = await instance.preference;
    return pref.containsKey(key);
  }

  Future<String> getStr(String key) async {
    var pref = await instance.preference;
    return pref.getString(key)!;
  }

  remove(String key) async {
    var pref = await instance.preference;
    pref.remove(key);
  }
}
