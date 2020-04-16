import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/unauthorized_user_redirect_interceptor.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock_classes.dart';
import '../../../../test_constants.dart';

void main() {
  group('Unauthorized user redirect inteceptor tests', () {
    final mockRouter = MockRouter();
    final mockTokenRepository = MockTokenRepository();
    final mockUserRepository = MockUserRepository();
    final mockLocalSettingRepository = MockLocalSettingsRepository();

    setUp(() {
      reset(mockRouter);
      reset(mockTokenRepository);
    });

    test('the app should navigate to login page on 401, not yet logged out',
        () async {
      when(mockTokenRepository.getLoginToken())
          .thenAnswer((_) => Future.value(TestConstants.stubLoginToken));

      final stubDioException = DioError(
          request: RequestOptions(
            path: '/authorizedpath',
          ),
          response: Response(statusCode: 401));

      await UnauthorizedUserRedirectInterceptor(mockRouter, mockTokenRepository,
              mockUserRepository, mockLocalSettingRepository)
          .onError(stubDioException);

      verify(mockRouter.navigateToLoginPage(
        unauthorizedInterceptorRedirection: true,
      )).called(1);
      verify(mockTokenRepository.deleteLoginToken()).called(1);
    });

    test('the app should not navigate to login page on an anonymous path',
        () async {
      final stubDioException = DioError(
          request: RequestOptions(
            path: CustomerApi.loginPath,
          ),
          response: Response(statusCode: 401));

      await UnauthorizedUserRedirectInterceptor(mockRouter, mockTokenRepository,
              mockUserRepository, mockLocalSettingRepository)
          .onError(stubDioException);

      verifyNever(mockRouter.navigateToLoginPage(
        unauthorizedInterceptorRedirection: true,
      ));
      verifyNever(mockTokenRepository.deleteLoginToken());
    });

    test('the app should not navigate to login page if already logged out',
        () async {
      when(mockTokenRepository.getLoginToken())
          .thenAnswer((_) => Future.value(null));

      final stubDioException = DioError(
          request: RequestOptions(
            path: '/authorizedpath',
          ),
          response: Response(statusCode: 401));

      await UnauthorizedUserRedirectInterceptor(mockRouter, mockTokenRepository,
              mockUserRepository, mockLocalSettingRepository)
          .onError(stubDioException);

      verifyNever(mockRouter.navigateToLoginPage(
        unauthorizedInterceptorRedirection: true,
      ));
      verifyNever(mockTokenRepository.deleteLoginToken());
    });

    test(
        'the app should not navigate to login page on a non authorization '
        'error code', () async {
      final stubDioException = DioError(
          request: RequestOptions(
            path: '/authorizedpath',
          ),
          response: Response(statusCode: 500));

      await UnauthorizedUserRedirectInterceptor(mockRouter, mockTokenRepository,
              mockUserRepository, mockLocalSettingRepository)
          .onError(stubDioException);

      verifyNever(mockRouter.navigateToLoginPage(
        unauthorizedInterceptorRedirection: true,
      ));
      verifyNever(mockTokenRepository.deleteLoginToken());
    });
  });
}
