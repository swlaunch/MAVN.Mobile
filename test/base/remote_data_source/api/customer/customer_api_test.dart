import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/login_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/register_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

CustomerApi _subject;

void main() {
  mockServerHttpClientTest('CustomerApi', (httpClient) {
    setUpAll(() {
      _subject = CustomerApi(httpClient);
    });

    group('login', () {
      test('login 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/login/response/200.json');

        final response = await _subject.login(LoginRequestModel(
            TestConstants.stubEmail, TestConstants.stubPassword));

        expect(response.token, 'token12345');

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });

      test('login 400 invalid email format', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common_error_responses'
            '/400_invalid_email_format.json',
            statusCode: 400);

        await expectLater(
            () => _subject.login(LoginRequestModel(
                TestConstants.stubEmail, TestConstants.stubPassword)),
            throwsA(
              const ServiceException(
                ServiceExceptionType.invalidEmailFormat,
                message: 'InvalidEmailFormat stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });

      test('login 400 invalid password format', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common_error_responses'
            '/400_invalid_password_format.json',
            statusCode: 400);

        await expectLater(
            () => _subject.login(LoginRequestModel(
                TestConstants.stubEmail, TestConstants.stubPassword)),
            throwsA(
              const ServiceException(
                ServiceExceptionType.invalidPasswordFormat,
                message: 'InvalidPasswordFormat stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });

      test('login 400 invalid credentials', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/login/response/'
            '/400_invalid_credentials.json',
            statusCode: 400);

        await expectLater(
            () => _subject.login(LoginRequestModel(
                TestConstants.stubEmail, TestConstants.stubPassword)),
            throwsA(
              const ServiceException(
                ServiceExceptionType.invalidCredentials,
                message: 'InvalidCredentials stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });

      test('login 401 invalid attempt warning', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/login/response/'
            '/401_login_attempts_warning.json',
            statusCode: 401);

        await expectLater(
            () => _subject.login(LoginRequestModel(
                TestConstants.stubEmail, TestConstants.stubPassword)),
            throwsA(
              const LoginAttemptsWarningException(
                  ServiceExceptionType.loginAttemptsWarning,
                  message: 'You have N more attempts to sign in, '
                      'or your account will be temporarily locked.',
                  attemptsLeft: 5),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });

      test('login 429 too many attempts', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/login/response/'
            '/429_login_too_many_request.json',
            statusCode: 429);

        await expectLater(
            () => _subject.login(LoginRequestModel(
                TestConstants.stubEmail, TestConstants.stubPassword)),
            throwsA(
              const TooManyRequestException(
                  ServiceExceptionType.tooManyLoginRequest,
                  message: 'Your account has been locked. Try again in N min.',
                  retryPeriodInMinutes: 5),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/login/request/full.json',
          path: '/auth/login',
        );
      });
    });

    group('register', () {
      test('register 200, full', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/register/response/200.json');

        await _subject.register(
          RegisterRequestModel(
            email: TestConstants.stubEmail,
            password: TestConstants.stubPassword,
            firstName: TestConstants.stubFirstName,
            lastName: TestConstants.stubLastName,
            referralCode: TestConstants.stubReferralCode,
            countryOfNationalityId: TestConstants.stubCountryId,
          ),
        );

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/register/request/full.json',
          path: '/customers/register',
        );
      });

      test('register 200, referral code null', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/register/response/200.json');

        await _subject.register(
          RegisterRequestModel(
            email: TestConstants.stubEmail,
            password: TestConstants.stubPassword,
            firstName: TestConstants.stubFirstName,
            lastName: TestConstants.stubLastName,
            referralCode: null,
            countryOfNationalityId: TestConstants.stubCountryId,
          ),
        );

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/register/request/referral_code_null.json',
          path: '/customers/register',
        );
      });

      test('register 400 invalidEmailFormat', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common_error_responses'
            '/400_invalid_email_format.json',
            statusCode: 400);

        await expectLater(
            () => _subject.register(
                  RegisterRequestModel(
                    email: TestConstants.stubEmail,
                    password: TestConstants.stubPassword,
                    firstName: TestConstants.stubFirstName,
                    lastName: TestConstants.stubLastName,
                    referralCode: TestConstants.stubReferralCode,
                    countryOfNationalityId: TestConstants.stubCountryId,
                  ),
                ),
            throwsA(
              const ServiceException(
                ServiceExceptionType.invalidEmailFormat,
                message: 'InvalidEmailFormat stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/register/request/full.json',
          path: '/customers/register',
        );
      });

      test('register 400 invalidPasswordFormat', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common_error_responses'
            '/400_invalid_password_format.json',
            statusCode: 400);

        await expectLater(
            () => _subject.register(
                  RegisterRequestModel(
                    email: TestConstants.stubEmail,
                    password: TestConstants.stubPassword,
                    firstName: TestConstants.stubFirstName,
                    lastName: TestConstants.stubLastName,
                    referralCode: TestConstants.stubReferralCode,
                    countryOfNationalityId: TestConstants.stubCountryId,
                  ),
                ),
            throwsA(
              const ServiceException(
                ServiceExceptionType.invalidPasswordFormat,
                message: 'InvalidPasswordFormat stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/register/request/full.json',
          path: '/customers/register',
        );
      });

      test('register 400 loginAlreadyInUse', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/register/response'
            '/400_login_already_in_use.json',
            statusCode: 400);

        await expectLater(
            () => _subject.register(
                  RegisterRequestModel(
                    email: TestConstants.stubEmail,
                    password: TestConstants.stubPassword,
                    firstName: TestConstants.stubFirstName,
                    lastName: TestConstants.stubLastName,
                    referralCode: TestConstants.stubReferralCode,
                    countryOfNationalityId: TestConstants.stubCountryId,
                  ),
                ),
            throwsA(
              const ServiceException(
                ServiceExceptionType.loginAlreadyInUse,
                message: 'LoginAlreadyInUse stub message',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/register/request/full.json',
          path: '/customers/register',
        );
      });
    });

    group('get customer', () {
      test('get customer success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/customer/response/200.json');

        final response = await _subject.getCustomer();

        expect(response.firstName, TestConstants.stubFirstName);
        expect(response.lastName, TestConstants.stubLastName);
        expect(response.email, TestConstants.stubEmail);
        expect(response.phoneNumber, TestConstants.stubPhoneNumber);
        expect(response.isPhoneNumberVerified, true);
        expect(response.isEmailVerified, true);
        expect(response.countryOfNationalityId, TestConstants.stubCountryId);
        expect(
            response.countryOfNationalityName, TestConstants.stubCountryName);

        httpClient.assertGetRequest(path: '/customers');
      });

      test('get customer error - 401 unauthorized', () async {
        httpClient.mockResponse(null, statusCode: 401);

        await expectLater(
          () => _subject.getCustomer(),
          throwsA(predicate((e) =>
              e is DioError &&
              e.type == DioErrorType.RESPONSE &&
              e.message == 'Http status error [401]')),
        );

        httpClient.assertGetRequest(path: '/customers');
      });
    });
  });
}
