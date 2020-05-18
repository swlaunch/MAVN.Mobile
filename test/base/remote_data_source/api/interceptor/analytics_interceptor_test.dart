import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/analytics_interceptor.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_analytics/network_analytics_event.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock_classes.dart';
import '../../../../test_constants.dart';

final AnalyticsService mockAnalyticsService = MockAnalyticsService();
final _subject = AnalyticsInterceptor(mockAnalyticsService);

void main() {
  group('Analytics inteceptor tests', () {
    test('send event on succesful response', () async {
      final stubResponse = Response(
        request: RequestOptions(path: '/customers/register', method: 'POST'),
        statusCode: 200,
      );

      await _subject.onResponse(stubResponse);

      final verifiedCall = verify(await mockAnalyticsService.logEvent(
        analyticsEvent: captureAnyNamed('analyticsEvent'),
      ));

      expect(verifiedCall.callCount, 1);

      final NetworkAnalyticsEvent capturedAnalyticsEvent =
          verifiedCall.captured[0];

      expect(capturedAnalyticsEvent.feature, 'registration');
      expect(capturedAnalyticsEvent.path, '/customers/register');
      expect(capturedAnalyticsEvent.method, 'POST');
      expect(capturedAnalyticsEvent.outcome, Outcome.success);
      expect(capturedAnalyticsEvent.responseCode, 200);
      expect(capturedAnalyticsEvent.success, true);
    });

    test('send event on response error', () async {
      final stubRequest = RequestOptions(path: '/auth/login', method: 'POST');
      final stubResponse = Response(
        request: stubRequest,
        data: {'error': 'responseBodyError'},
        statusCode: 408,
      );

      final dioException = DioError(
        request: stubRequest,
        response: stubResponse,
        type: DioErrorType.RESPONSE,
      );

      await _subject.onError(dioException);

      final verifiedCall = verify(await mockAnalyticsService.logEvent(
        analyticsEvent: captureAnyNamed('analyticsEvent'),
      ));

      expect(verifiedCall.callCount, 1);

      final NetworkAnalyticsEvent capturedAnalyticsEvent =
          verifiedCall.captured[0];

      expect(capturedAnalyticsEvent.feature, 'login');
      expect(capturedAnalyticsEvent.path, '/auth/login');
      expect(capturedAnalyticsEvent.method, 'POST');
      expect(capturedAnalyticsEvent.outcome, Outcome.responseError);
      expect(capturedAnalyticsEvent.responseCode, 408);
      expect(capturedAnalyticsEvent.responseBodyError, 'response_body_error');
      expect(capturedAnalyticsEvent.success, false);
    });

    test('send event on timeout error', () async {
      final stubRequest = RequestOptions(path: '/auth/login', method: 'POST');

      final dioException = DioError(
        request: stubRequest,
        type: DioErrorType.RECEIVE_TIMEOUT,
      );

      await _subject.onError(dioException);

      final verifiedCall = verify(await mockAnalyticsService.logEvent(
        analyticsEvent: captureAnyNamed('analyticsEvent'),
      ));

      expect(verifiedCall.callCount, 1);

      final NetworkAnalyticsEvent capturedAnalyticsEvent =
          verifiedCall.captured[0];

      expect(capturedAnalyticsEvent.path, '/auth/login');
      expect(capturedAnalyticsEvent.method, 'POST');
      expect(capturedAnalyticsEvent.outcome, Outcome.timeoutError);
      expect(capturedAnalyticsEvent.responseCode, null);
      expect(capturedAnalyticsEvent.responseBodyError, null);
      expect(capturedAnalyticsEvent.success, false);
    });

    test('do not send error event if request was cancelled', () async {
      final stubResponse = Response(
        request: RequestOptions(path: TestConstants.stubPath, method: 'POST'),
        statusCode: 408,
      );

      final dioException = DioError(
        response: stubResponse,
        type: DioErrorType.CANCEL,
      );

      await _subject.onError(dioException);

      verifyNever(await mockAnalyticsService.logEvent(
        analyticsEvent: captureAnyNamed('analyticsEvent'),
      ));
    });

    test('get outcome enum from error type', () {
      expect(
        _subject.getOutcome(DioError(type: DioErrorType.CONNECT_TIMEOUT)),
        Outcome.timeoutError,
      );

      expect(
        _subject.getOutcome(DioError(type: DioErrorType.RECEIVE_TIMEOUT)),
        Outcome.timeoutError,
      );

      expect(
        _subject.getOutcome(DioError(type: DioErrorType.SEND_TIMEOUT)),
        Outcome.timeoutError,
      );

      expect(
        _subject.getOutcome(DioError(type: DioErrorType.RESPONSE)),
        Outcome.responseError,
      );

      expect(
        _subject.getOutcome(DioError(type: DioErrorType.DEFAULT)),
        Outcome.unknownError,
      );

      expect(
        _subject.getOutcome(DioError(type: DioErrorType.CANCEL)),
        Outcome.unknownError,
      );
    });

    test('get feature from url path', () {
      expect(
        _subject.getFeatureFromUrlPath('/auth/login'),
        'login',
      );

      expect(
        _subject.getFeatureFromUrlPath('/customers/register'),
        'registration',
      );

      expect(
        _subject.getFeatureFromUrlPath('/wallets/customer'),
        'balance',
      );

      expect(
        _subject.getFeatureFromUrlPath('/referrals/lead'),
        'lead_referral',
      );

      expect(
        _subject.getFeatureFromUrlPath('unknown/path'),
        null,
      );
    });
  });
}
