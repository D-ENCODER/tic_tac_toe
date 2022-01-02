import 'package:get_storage/get_storage.dart';

class Storage {
  final GetStorage _prefs = GetStorage();

  String getUID() {
    return _prefs.read('uid');
  }

  Future<void> setUID(String uid) async {
    return _prefs.write('uid', uid);
  }

  Future<void> clearUID() async {
    return _prefs.remove('uid');
  }

  String getGameCode() {
    return _prefs.read('code');
  }

  Future<void> setGameCode(String code) {
    return _prefs.write('code', code);
  }

  Future<void> clearGameCode() {
    return _prefs.remove('code');
  }
}
