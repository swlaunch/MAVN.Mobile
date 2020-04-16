import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_keys.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

final MockSharedPreferencesManager _mockSharedPreferencesManager =
    MockSharedPreferencesManager();

LocalSettingsRepository _subject;

void main() {
  setUp(() {
    reset(_mockSharedPreferencesManager);
    _subject = LocalSettingsRepository(
      _mockSharedPreferencesManager,
    );
  });

  group('setIsFirstRun', () {
    test('true', () {
      _subject.setIsFirstRun(value: true);

      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.isFirstRun,
        value: true,
      ));
    });

    test('false', () {
      _subject.setIsFirstRun(value: false);

      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.isFirstRun,
        value: false,
      ));
    });
  });

  group('isFirstRun', () {
    test('true', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.isFirstRun,
      )).thenReturn(true);

      expect(_subject.isFirstRun(), true);
    });

    test('false', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.isFirstRun,
      )).thenReturn(false);

      expect(_subject.isFirstRun(), false);
    });
  });

  group('setUserShouldSeeOnboarding', () {
    test('true', () {
      _subject.setUserShouldSeeOnboarding(
        shouldSeeOnboarding: true,
      );

      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.shouldSeeOnboarding,
        value: true,
      ));
    });

    test('false', () {
      _subject.setUserShouldSeeOnboarding(
        shouldSeeOnboarding: false,
      );
      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.shouldSeeOnboarding,
        value: false,
      ));
    });
  });

  group('getUserShouldSeeOnboarding', () {
    test('true', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.shouldSeeOnboarding,
      )).thenReturn(true);

      expect(_subject.getUserShouldSeeOnboarding(), true);
    });

    test('false', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.shouldSeeOnboarding,
      )).thenReturn(false);

      expect(_subject.getUserShouldSeeOnboarding(), false);
    });
  });

  group('getUserHasAcceptedBiometricAuthentication', () {
    test('true', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.hasEnabledBiometrics,
      )).thenReturn(true);

      expect(
        _subject.getUserHasAcceptedBiometricAuthentication(),
        true,
      );
    });

    test('false', () {
      when(_mockSharedPreferencesManager.readBool(
        key: SharedPreferencesKeys.hasEnabledBiometrics,
      )).thenReturn(false);

      expect(
        _subject.getUserHasAcceptedBiometricAuthentication(),
        false,
      );
    });
  });

  group('setUserHasAcceptedBiometricAuthentication', () {
    test('true', () {
      _subject.setUserHasAcceptedBiometricAuthentication(
        accepted: true,
      );
      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.hasEnabledBiometrics,
        value: true,
      ));
    });
    test('false', () {
      _subject.setUserHasAcceptedBiometricAuthentication(
        accepted: false,
      );
      verify(_mockSharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.hasEnabledBiometrics,
        value: false,
      ));
    });
  });

  test('getCountBiometricRejections', () {
    when(_mockSharedPreferencesManager.readInt(
      key: SharedPreferencesKeys.countRejectedBiometrics,
    )).thenReturn(TestConstants.stubTotalCount);

    expect(
      _subject.getCountBiometricRejections(),
      TestConstants.stubTotalCount,
    );
  });

  test('setCountBiometricRejections', () {
    _subject.setCountBiometricRejections(
      TestConstants.stubTotalCount,
    );
    verify(_mockSharedPreferencesManager.writeInt(
      key: SharedPreferencesKeys.countRejectedBiometrics,
      value: TestConstants.stubTotalCount,
    ));
  });

  test('getLastBiometricRejectionTimeStamp', () {
    when(_mockSharedPreferencesManager.readInt(
      key: SharedPreferencesKeys.lastRejectedBiometrics,
    )).thenReturn(TestConstants.stubTimestamp);

    expect(
      _subject.getLastBiometricRejectionTimeStamp(),
      TestConstants.stubTimestamp,
    );
  });

  test('setLastBiometricRejectionTimeStamp', () {
    _subject.setLastBiometricRejectionTimeStamp(
      TestConstants.stubTimestamp,
    );
    verify(_mockSharedPreferencesManager.writeInt(
      key: SharedPreferencesKeys.lastRejectedBiometrics,
      value: TestConstants.stubTimestamp,
    ));
  });

  test('storeHotelReferralCode', () {
    _subject.storeHotelReferralCode(
      TestConstants.stubReferralCode,
    );
    verify(_mockSharedPreferencesManager.write(
      key: SharedPreferencesKeys.hotelReferralCode,
      value: TestConstants.stubReferralCode,
    ));
  });

  test('getHotelReferralCode', () {
    when(_mockSharedPreferencesManager.read(
      key: SharedPreferencesKeys.hotelReferralCode,
    )).thenReturn(TestConstants.stubReferralCode);

    expect(
      _subject.getHotelReferralCode(),
      TestConstants.stubReferralCode,
    );
  });

  test('removeHotelReferralCode', () {
    _subject.removeHotelReferralCode();
    verify(_mockSharedPreferencesManager.remove(
      key: SharedPreferencesKeys.hotelReferralCode,
    )).called(1);
  });

  test('storeEmailVerificationCode', () {
    _subject.storeEmailVerificationCode(
      TestConstants.stubEmailVerificationCode,
    );
    verify(_mockSharedPreferencesManager.write(
      key: SharedPreferencesKeys.emailConfirmationCode,
      value: TestConstants.stubEmailVerificationCode,
    )).called(1);
  });

  test('getEmailVerificationCode', () {
    when(_mockSharedPreferencesManager.read(
      key: SharedPreferencesKeys.emailConfirmationCode,
    )).thenReturn(TestConstants.stubEmailVerificationCode);

    expect(
      _subject.getEmailVerificationCode(),
      TestConstants.stubEmailVerificationCode,
    );
  });

  test('removeEmailVerificationCode', () {
    _subject.removeEmailVerificationCode();
    verify(_mockSharedPreferencesManager.remove(
      key: SharedPreferencesKeys.emailConfirmationCode,
    )).called(1);
  });

  test('storeMobileSettings', () {
    _subject.storeMobileSettings(TestConstants.stubMobileSettings);
    verify(_mockSharedPreferencesManager.write(
            key: SharedPreferencesKeys.mobileSettings,
            value: json.encode(TestConstants.stubMobileSettings)))
        .called(1);
  });

  group('getMobileSettings', () {
    test('non-null value', () {
      when(_mockSharedPreferencesManager.read(
        key: SharedPreferencesKeys.mobileSettings,
      )).thenReturn(json.encode(TestConstants.stubMobileSettings));

      expect(
        _subject.getMobileSettings(),
        TestConstants.stubMobileSettings,
      );
    });

    test('null', () {
      when(_mockSharedPreferencesManager.read(
        key: SharedPreferencesKeys.mobileSettings,
      )).thenReturn(null);

      expect(
        _subject.getMobileSettings(),
        null,
      );
    });
  });

  test('setLastAppVersionUpgradeDialogPrompt', () {
    _subject.setLastAppVersionUpgradeDialogPrompt(
      value: TestConstants.stubLatestAppVersion,
    );
    verify(_mockSharedPreferencesManager.write(
      key: SharedPreferencesKeys.lastAppVersionUpgradeDialogPrompt,
      value: TestConstants.stubLatestAppVersion,
    ));
  });

  group('getLastAppVersionUpgradeDialogPrompt', () {
    test('non-null value', () {
      when(_mockSharedPreferencesManager.read(
        key: SharedPreferencesKeys.lastAppVersionUpgradeDialogPrompt,
      )).thenReturn(TestConstants.stubLatestAppVersion);

      expect(
        _subject.getLastAppVersionUpgradeDialogPrompt(),
        TestConstants.stubLatestAppVersion,
      );
    });

    test('null', () {
      when(_mockSharedPreferencesManager.read(
        key: SharedPreferencesKeys.lastAppVersionUpgradeDialogPrompt,
      )).thenReturn(null);

      expect(
        _subject.getLastAppVersionUpgradeDialogPrompt(),
        minAppVersion,
      );
    });
  });
}
