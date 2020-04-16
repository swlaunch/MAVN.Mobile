import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LogOutUseCase {
  LogOutUseCase(
    this._tokenRepository,
    this._userRepository,
    this._customerRepository,
    this._localSettingsRepository,
    this._firebaseMessaging,
  );

  final LocalSettingsRepository _localSettingsRepository;
  final TokenRepository _tokenRepository;
  final UserRepository _userRepository;
  final CustomerRepository _customerRepository;
  final FirebaseMessaging _firebaseMessaging;

  Future<void> execute({bool serverLogout = true}) async {
    if (serverLogout) {
      await _unregisterFromPushNotifications();
      await _logout();
    }

    await _tokenRepository.deleteLoginToken();
    await _userRepository.wipeData();
    await _localSettingsRepository.setUserVerified(isVerified: false);
    await _localSettingsRepository.removeEmailVerificationCode();
    await _localSettingsRepository.clearHasPIN();
  }

  Future<void> _logout() async {
    try {
      await _customerRepository.logout();
    } catch (_) {}
    //We need to logout the user even if this request fails
  }

  Future<void> _unregisterFromPushNotifications() async {
    try {
      final firebaseToken = await _firebaseMessaging.getToken();

      if (firebaseToken == null) {
        return;
      }

      await _customerRepository.unregisterFromPushNotifications(
          pushRegistrationToken: firebaseToken);
    } catch (_) {}
    // ignore: lines_longer_than_80_chars
    // As push notification unregistering is more as a side effect,
    // for now we can ignore the errors in case the API Endpoint fails
  }
}

LogOutUseCase useLogOutUseCase({BuildContext context}) =>
    ModuleProvider.of<AppModule>(
      context ?? useContext(),
      listen: false,
    ).logoutUseCase;
