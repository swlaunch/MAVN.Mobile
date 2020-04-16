import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'debug_menu_bloc_output.dart';

export 'debug_menu_bloc_output.dart';

class DebugMenuBloc extends Bloc<DebugMenuState> {
  DebugMenuBloc(this._sharedPreferencesManager, this._secureStore);

  final SharedPreferencesManager _sharedPreferencesManager;
  final SecureStore _secureStore;

  @override
  DebugMenuState initialState() => DebugMenuState(
        proxyUrl:
            _sharedPreferencesManager.read(key: SharedPreferencesKeys.proxyUrl),
      );

  Future<void> saveProxyUrl(String newProxyUrl) async {
    await _sharedPreferencesManager.write(
        key: SharedPreferencesKeys.proxyUrl, value: newProxyUrl);

    setState(currentState.copyWith(proxyUrl: newProxyUrl));
  }

  Future<void> clearProxyUrl() async => saveProxyUrl('');

  Future<void> expireSession() async => _secureStore.write(
      key: SecureStoreKeys.loginToken, value: 'invalidToken');

  Future<void> clearSecureStorage() async => _secureStore.deleteAll();
}

DebugMenuBloc useDebugMenuBloc() =>
    ModuleProvider.of<AppModule>(useContext()).debugMenuBloc;
