import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

void main() {
  group('LogOutUseCase tests', () {
    final mockTokenRepository = MockTokenRepository();
    final mockUserRepository = MockUserRepository();
    final mockCustomerRepository = MockCustomerRepository();
    final mockLocalSettingsRepository = MockLocalSettingsRepository();
    final mockFirebaseMessaging = MockFirebaseMessaging();
    LogOutUseCase subject;

    setUp(() {
      subject = LogOutUseCase(
        mockTokenRepository,
        mockUserRepository,
        mockCustomerRepository,
        mockLocalSettingsRepository,
        mockFirebaseMessaging,
      );
    });

    test('success path', () async {
      when(mockFirebaseMessaging.getToken())
          .thenAnswer((_) => Future.value(''));

      await subject.execute();

      verify(mockCustomerRepository.unregisterFromPushNotifications(
              pushRegistrationToken: ''))
          .called(1);
      verify(mockCustomerRepository.logout()).called(1);
      verify(mockFirebaseMessaging.getToken()).called(1);
      verify(mockTokenRepository.deleteLoginToken()).called(1);
      verify(mockUserRepository.wipeData()).called(1);
      verify(mockLocalSettingsRepository.setUserVerified(isVerified: false))
          .called(1);
    });

    test('error path', () async {
      when(mockFirebaseMessaging.getToken())
          .thenAnswer((_) => Future.value(null));

      when(mockFirebaseMessaging.getToken()).thenThrow(Exception());
      when(mockCustomerRepository.logout()).thenThrow(Exception());

      await subject.execute();

      verifyNever(mockCustomerRepository.unregisterFromPushNotifications(
          pushRegistrationToken: ''));
      verify(mockCustomerRepository.logout()).called(1);
      verify(mockFirebaseMessaging.getToken()).called(1);
      verify(mockTokenRepository.deleteLoginToken()).called(1);
      verify(mockUserRepository.wipeData()).called(1);
      verify(mockLocalSettingsRepository.setUserVerified(isVerified: false))
          .called(1);
    });
  });
}
