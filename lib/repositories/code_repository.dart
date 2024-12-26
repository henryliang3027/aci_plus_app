import 'package:aci_plus_app/core/shared_preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 紀錄員工輸入的編號在 SharedPreferences
class CodeRepository {
  CodeRepository();

  Future<void> writeUserCode(String userCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKey.userCode.name, userCode);
  }

  Future<String> readUserCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCode = prefs.getString(SharedPreferenceKey.userCode.name) ?? '';
    return userCode;
  }
}
