import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future saveToken(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString('token', value);
  }

  Future readToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return await _preferences.getString('token');
  }

  Future removeToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.remove('token');
  }

  Future saveFullName(value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString('full_name', value);
  }

  Future readFullName() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return await _preferences.getString('full_name');
  }

  Future saveId(int value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setInt('id', value);
  }

  Future readId() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return await _preferences.getInt('id');
  }

  Future destoryAll() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.remove('full_name');
    await _preferences.remove('token');
    await _preferences.remove('id');
    await _preferences.clear();
  }
}
