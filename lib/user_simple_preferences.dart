import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUserphone = 'userphone';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserPhone(String num) async {
    await _preferences.setString(_keyUserphone, num);
  }

  static String getUserPhone() => _preferences.getString(_keyUserphone);
}
