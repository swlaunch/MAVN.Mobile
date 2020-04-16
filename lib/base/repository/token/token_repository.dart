import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TokenRepository {
  TokenRepository(this._secureStore);

  final SecureStore _secureStore;

//  Login Token
  Future<String> getLoginToken() =>
      _secureStore.read(key: SecureStoreKeys.loginToken);

  Future<void> setLoginToken(String token) =>
      _secureStore.write(key: SecureStoreKeys.loginToken, value: token);

  Future<void> deleteLoginToken() =>
      _secureStore.delete(key: SecureStoreKeys.loginToken);
}

TokenRepository useTokenRepository(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).tokenRepository;
