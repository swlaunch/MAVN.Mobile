import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_mapper.dart';

import '../../../../helpers/file.dart';

LoginMapper subject;

void main() {
  group('API exceptions', () {
    group('LoginMapper tests', () {
      setUp(() {
        subject = LoginMapper();
      });

      test('TooManyRequestException DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/login/response/'
            '/429_login_too_many_request.json',
            429);

        exception = subject.map(exception);

        expect(
          exception,
          const TooManyRequestException(
              ServiceExceptionType.tooManyLoginRequest,
              message: 'Your account has been locked. Try again in N min.',
              retryPeriodInMinutes: 5),
        );
      });

      test('LoginAttemptsWarningException DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/login/response/'
            '/401_login_attempts_warning.json',
            401);

        exception = subject.map(exception);

        expect(
          exception,
          const LoginAttemptsWarningException(
              ServiceExceptionType.loginAttemptsWarning,
              message: 'You have N more attempts to sign in, '
                  'or your account will be temporarily locked.',
              attemptsLeft: 5),
        );
      });

      test('CONNECT_TIMEOUT -> NetworkException', () {
        expect(
          subject.map(DioError(type: DioErrorType.CONNECT_TIMEOUT)),
          isInstanceOf<NetworkException>(),
        );
      });

      test('RECEIVE_TIMEOUT -> NetworkException', () {
        expect(
          subject.map(DioError(type: DioErrorType.RECEIVE_TIMEOUT)),
          isInstanceOf<NetworkException>(),
        );
      });

      test('SocketException -> NetworkException', () {
        expect(
          subject.map(DioError(
              type: DioErrorType.DEFAULT,
              error: 'something SocketException something')),
          isInstanceOf<NetworkException>(),
        );
      });

      test('DEFAULT DioError does not map', () {
        final exception = DioError(type: DioErrorType.DEFAULT);

        expect(
          subject.map(exception),
          exception,
        );
      });

      test('Unhandled exception does not map', () {
        final unhandledException = Exception();

        expect(
          subject.map(unhandledException),
          unhandledException,
        );
      });

      test('empty DioErrorType.RESPONSE does not map', () {
        final error = DioError(type: DioErrorType.RESPONSE);

        expect(
          subject.map(error),
          error,
        );
      });

      test('InvalidEmailFormat DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/common_error_responses/'
            '/400_invalid_email_format.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.invalidEmailFormat,
            message: 'InvalidEmailFormat stub message',
          ),
        );
      });

      test('InvalidPasswordFormat DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/common_error_responses/'
            '/400_invalid_password_format.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.invalidPasswordFormat,
            message: 'InvalidPasswordFormat stub message',
          ),
        );
      });

      test('InvalidCredentials DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/login/response'
            '/400_invalid_credentials.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.invalidCredentials,
            message: 'InvalidCredentials stub message',
          ),
        );
      });

      test('LoginAlreadyInUse DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/register/response'
            '/400_login_already_in_use.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.loginAlreadyInUse,
            message: 'LoginAlreadyInUse stub message',
          ),
        );
      });

      test('ReferralAlreadyConfirmed DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/referrals/hotels/response'
            '/400_referral_already_confirmed.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.referralAlreadyConfirmed,
            message: 'ReferralAlreadyConfirmed stub message',
          ),
        );
      });

      test('ReferralLimitExceeded DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/referrals/hotels/response'
            '/400_referrals_limit_exceeded.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.referralsLimitExceeded,
            message: 'ReferralsLimitExceeded stub message',
          ),
        );
      });

      test('CustomerBlocked DioErrorType.RESPONSE', () {
        var exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/login/response'
            '/400_customer_is_blocked.json',
            400);

        exception = subject.map(exception);

        expect(
          exception,
          const ServiceException(
            ServiceExceptionType.customerBlocked,
            message: 'CustomerBlocked stub message',
          ),
        );
      });

      test('Unknown error DioErrorType.RESPONSE', () {
        final exception = _getDioErrorWithResponseFromFile(
            'test_resources/mock_data/common_error_responses'
            '/400_unknown_error.json',
            400);

        expect(subject.map(exception), exception);
      });
    });
  });
}

Exception _getDioErrorWithResponseFromFile(String fileName, int statusCode) =>
    DioError(
        type: DioErrorType.RESPONSE,
        response: dioResponseFromFile(fileName, statusCode: statusCode));
