import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

void main() {
  group('ExceptionToMessageMapper tests', () {
    final _mockLocalSettingsRepository = MockLocalSettingsRepository();
    final LocalizedStrings localizedStrings = LocalizedStrings();

    ExceptionToMessageMapper _subject;

    setUp(() {
      reset(_mockLocalSettingsRepository);
      _subject = ExceptionToMessageMapper(_mockLocalSettingsRepository);
    });

    test('generic error', () async {
      final target = _subject.map(Exception()).from(localizedStrings);

      expect(target, localizedStrings.defaultGenericError);
    });

    test('network error', () async {
      final target = _subject.map(NetworkException()).from(localizedStrings);

      expect(target, localizedStrings.networkError);
    });

    test('server error - email is already verified', () async {
      final target = _subject
          .map(const ServiceException(
              ServiceExceptionType.emailIsAlreadyVerified))
          .from(localizedStrings);

      expect(target, localizedStrings.emailIsAlreadyVerifiedError);
    });

    test('too many requests', () async {
      final target = _subject
          .map(const TooManyRequestException(
              ServiceExceptionType.tooManyLoginRequest,
              message: 'message',
              retryPeriodInMinutes: 3))
          .from(localizedStrings);

      expect(target, localizedStrings.loginPageTooManyRequestMessage(3));
    });

    test('login attempts warning', () async {
      final target = _subject
          .map(const LoginAttemptsWarningException(
              ServiceExceptionType.loginAttemptsWarning,
              message: 'message',
              attemptsLeft: 1))
          .from(localizedStrings);

      expect(target, localizedStrings.loginPageLoginAttemptWarningMessage(1));
    });
  });
}
