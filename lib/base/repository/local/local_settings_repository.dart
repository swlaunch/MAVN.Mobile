import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:package_info/package_info.dart';

const defaultPrecision = 2;

// use 0.0.1 because 0.0.0 is not a valid "Version"
const minAppVersion = '0.0.1';

class LocalSettingsRepository {
  const LocalSettingsRepository(this._sharedPreferencesManager);

  final SharedPreferencesManager _sharedPreferencesManager;

  void setIsFirstRun({@required bool value}) {
    _sharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.isFirstRun, value: value);
  }

  bool isFirstRun() =>
      _sharedPreferencesManager.readBool(key: SharedPreferencesKeys.isFirstRun);

  Future<void> setUserVerified({bool isVerified}) {
    _sharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.isUserVerified, value: isVerified);
  }

  bool isUserVerified() =>
      _sharedPreferencesManager.readBool(
          key: SharedPreferencesKeys.isUserVerified) ??
      false;

  void setUserShouldSeeOnboarding({bool shouldSeeOnboarding}) {
    _sharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.shouldSeeOnboarding,
        value: shouldSeeOnboarding);
  }

  bool getUserShouldSeeOnboarding() =>
      _sharedPreferencesManager.readBool(
          key: SharedPreferencesKeys.shouldSeeOnboarding) ??
      true;

  bool getUserHasAcceptedBiometricAuthentication() =>
      _sharedPreferencesManager.readBool(
          key: SharedPreferencesKeys.hasEnabledBiometrics) ??
      false;

  Future<void> setUserHasAcceptedBiometricAuthentication({bool accepted}) =>
      _sharedPreferencesManager.writeBool(
          key: SharedPreferencesKeys.hasEnabledBiometrics, value: accepted);

  int getCountBiometricRejections() => _sharedPreferencesManager.readInt(
      key: SharedPreferencesKeys.countRejectedBiometrics);

  void setCountBiometricRejections(int newCount) =>
      _sharedPreferencesManager.writeInt(
          key: SharedPreferencesKeys.countRejectedBiometrics, value: newCount);

  int getLastBiometricRejectionTimeStamp() => _sharedPreferencesManager.readInt(
      key: SharedPreferencesKeys.lastRejectedBiometrics);

  void setLastBiometricRejectionTimeStamp(int newTimeStamp) =>
      _sharedPreferencesManager.writeInt(
          key: SharedPreferencesKeys.lastRejectedBiometrics,
          value: newTimeStamp);

  Future<void> storeHotelReferralCode(String code) async {
    await _sharedPreferencesManager.write(
      key: SharedPreferencesKeys.hotelReferralCode,
      value: code,
    );
  }

  String getHotelReferralCode() => _sharedPreferencesManager.read(
      key: SharedPreferencesKeys.hotelReferralCode);

  Future<void> removeHotelReferralCode() => _sharedPreferencesManager.remove(
      key: SharedPreferencesKeys.hotelReferralCode);

  Future<void> storeLeadReferralCode(String code) async {
    await _sharedPreferencesManager.write(
      key: SharedPreferencesKeys.leadReferralCode,
      value: code,
    );
  }

  String getLeadReferralCode() => _sharedPreferencesManager.read(
      key: SharedPreferencesKeys.leadReferralCode);

  Future<void> removeLeadReferralCode() => _sharedPreferencesManager.remove(
      key: SharedPreferencesKeys.leadReferralCode);

  Future<void> storeEmailVerificationCode(String code) async {
    await _sharedPreferencesManager.write(
      key: SharedPreferencesKeys.emailConfirmationCode,
      value: code,
    );
  }

  String getEmailVerificationCode() => _sharedPreferencesManager.read(
      key: SharedPreferencesKeys.emailConfirmationCode);

  Future<void> removeEmailVerificationCode() => _sharedPreferencesManager
      .remove(key: SharedPreferencesKeys.emailConfirmationCode);

  Future<void> storeMobileSettings(MobileSettings mobileSettings) async {
    await _sharedPreferencesManager.write(
        key: SharedPreferencesKeys.mobileSettings,
        value: json.encode(mobileSettings));
  }

  MobileSettings getMobileSettings() {
    try {
      final fetchedJson = _sharedPreferencesManager.read(
          key: SharedPreferencesKeys.mobileSettings);
      return fetchedJson == null
          ? null
          : MobileSettings.fromJson(json.decode(fetchedJson));
    } on Exception catch (_) {
      return null;
    }
  }

  Future<String> getCurrentAppVersion() async =>
      (await PackageInfo.fromPlatform()).version;

  void setLastAppVersionUpgradeDialogPrompt({@required String value}) {
    _sharedPreferencesManager.write(
      key: SharedPreferencesKeys.lastAppVersionUpgradeDialogPrompt,
      value: value,
    );
  }

  String getLastAppVersionUpgradeDialogPrompt() =>
      _sharedPreferencesManager.read(
          key: SharedPreferencesKeys.lastAppVersionUpgradeDialogPrompt) ??
      minAppVersion;

  bool didForgetPin() =>
      _sharedPreferencesManager.readBool(
          key: SharedPreferencesKeys.forgottenPin) ??
      false;

  Future<void> clearDidForgetPin() =>
      _sharedPreferencesManager.remove(key: SharedPreferencesKeys.forgottenPin);

  bool hasPIN() =>
      _sharedPreferencesManager.readBool(key: SharedPreferencesKeys.hasPIN);

  Future<void> clearHasPIN() =>
      _sharedPreferencesManager.remove(key: SharedPreferencesKeys.hasPIN);

  Future<void> setHasPIN({bool hasPIN}) => _sharedPreferencesManager.writeBool(
      key: SharedPreferencesKeys.hasPIN, value: hasPIN);

  bool getIsDarkMode() =>
      _sharedPreferencesManager.readBool(key: SharedPreferencesKeys.isDarkMode);

  Future<void> setIsDarkMode({bool isDarkMode}) => _sharedPreferencesManager
      .writeBool(key: SharedPreferencesKeys.isDarkMode, value: isDarkMode);
}

LocalSettingsRepository useLocalSettingsRepository() =>
    ModuleProvider.of<AppModule>(useContext()).localSettingsRepository;
