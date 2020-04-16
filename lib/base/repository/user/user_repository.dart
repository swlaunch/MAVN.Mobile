import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class UserRepository {
  UserRepository(this._secureStore);

  final SecureStore _secureStore;

  Future<String> getCustomerEmail() =>
      _secureStore.read(key: SecureStoreKeys.customerEmail);

  Future<void> setCustomerEmail(String email) =>
      _secureStore.write(key: SecureStoreKeys.customerEmail, value: email);

  Future<String> getCustomerPassword() =>
      _secureStore.read(key: SecureStoreKeys.customerPassword);

  Future<void> setCustomerPassword(String password) => _secureStore.write(
      key: SecureStoreKeys.customerPassword, value: password);

  ///TODO: From architectural perspective it would be better
  /// if the logic below is moved from the Repo to a UseCase
  Future<bool> hasBeenPreviouslyLoggedIn() async {
    final email = await getCustomerEmail();
    final password = await getCustomerPassword();
    return email != null && password != null;
  }

  Future<void> wipeData() {
    _secureStore
      ..delete(key: SecureStoreKeys.customerEmail)
      ..delete(key: SecureStoreKeys.customerPassword);
  }
}

UserRepository useUserRepository(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).userRepository;
