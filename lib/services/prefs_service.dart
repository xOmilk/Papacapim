import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getToken() {
    var token = _prefs.getString("token");
    return token;
  }

  Future<void> setToken(String token) async {
    await _prefs.setString("token", token);
  }

  String? getLogin() {
    var login = _prefs.getString("login");
    return login;
  }

  Future<void> setLogin(String login) async {
    await _prefs.setString("login", login);
  }

  Future<void> clearAuth() async {
    await _prefs.remove("token");
    await _prefs.remove("login");
  }
}
