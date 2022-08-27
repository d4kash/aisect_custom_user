import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  // static  SharedPreferences _pref;
  static String nameKey = "NAMEKEY";
  static String phoneKey = "PHONEKEY";
  static String faculty = "faclty";
  static String loggedin_uid = '';
  static bool onBoardVisited = false;
  // static Future init() async {
  //   _pref = await SharedPreferences.getInstance();
  // }

  static Future<bool> saveName(
    String name,
  ) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setString(
      nameKey,
      name,
    );
  }

  static Future<bool> savePhone(String phone) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setString(
      phoneKey,
      phone,
    );
  }

  static Future<bool> saveFaculty(String faculty) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setString(
      faculty,
      faculty,
    );
  }

  static Future<bool> saveUID() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setString(
      loggedin_uid,
      constuid,
    );
  }

  static Future<String?> getUID() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getString(
      loggedin_uid,
    );
  }

  static Future<bool> saveFirstTime(bool x) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setBool("alreadyVisited", x);
  }

  static Future<bool> checkForFirst() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getBool("alreadyVisited") ?? false;
  }

  static Future<bool> LogoutUser() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.setBool("LogoutCheck", true);
  }

  static Future<bool> getLogoutUser() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getBool(
          "LogoutCheck",
        ) ??
        false;
  }

  static Future<String?> getName() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getString(nameKey);
  }

  static Future<String?> getPhone() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getString(phoneKey);
  }

  static Future<String?> getfaculty() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return await _pref.getString(faculty);
  }
}
