import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'shared_preferences_keys.dart';

class SharedPreferencesManager {
  SharedPreferencesManager(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  String read({@required String key}) => _sharedPreferences.getString(key);

  bool readBool({@required String key}) => _sharedPreferences.getBool(key);

  int readInt({@required String key}) => _sharedPreferences.getInt(key);

  Future<void> write({@required String key, @required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  Future<void> remove({@required String key}) async {
    await _sharedPreferences.remove(key);
  }

  Future<void> writeBool({@required String key, @required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  Future<void> writeInt({@required String key, @required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }
}

SharedPreferencesManager useSharedPreferencesManager() =>
    ModuleProvider.of<AppModule>(useContext()).sharedPreferencesManager;
