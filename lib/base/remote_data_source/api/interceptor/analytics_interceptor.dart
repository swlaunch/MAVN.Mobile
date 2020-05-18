import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/wallet_api.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_analytics/network_analytics_event.dart';
import 'package:recase/recase.dart';

class AnalyticsInterceptor extends CustomInterceptor {
  AnalyticsInterceptor(this.analyticsService);

  final AnalyticsService analyticsService;

  @override
  Future<Response> onResponse(Response response) {
    if (response == null || response.request == null) {
      return Future.value(response);
    }

    final networkAnalyticsEvent = NetworkAnalyticsEvent(
      feature: getFeatureFromUrlPath(response.request.path),
      method: response.request.method,
      path: response.request.path,
      outcome: Outcome.success,
      responseCode: response.statusCode,
      success: true,
    );

    analyticsService.logEvent(analyticsEvent: networkAnalyticsEvent);

    return Future.value(response);
  }

  @override
  Future onError(DioError err) {
    if (err == null || err.type == DioErrorType.CANCEL) {
      return Future.value(err);
    }

    final networkAnalyticsEvent = NetworkAnalyticsEvent(
      feature: getFeatureFromUrlPath(err.request?.path),
      path: err.request?.path,
      method: err.request?.method,
      outcome: getOutcome(err),
      responseCode: err.response?.statusCode,
      responseBodyError: getResponseBodyError(err.response),
      success: false,
    );

    analyticsService.logEvent(analyticsEvent: networkAnalyticsEvent);

    return Future.value(err);
  }

  Outcome getOutcome(DioError dioException) {
    switch (dioException.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
        return Outcome.timeoutError;
      case DioErrorType.RESPONSE:
        return Outcome.responseError;
      default:
        return Outcome.unknownError;
    }
  }

  String getFeatureFromUrlPath(String urlPath) {
    switch (urlPath) {
      case CustomerApi.loginPath:
        return Feature.login;
      case CustomerApi.registerPath:
        return Feature.registration;
      case WalletApi.getWalletPath:
        return Feature.balance;
      default:
        return null;
    }
  }

  String getResponseBodyError(Response response) {
    if (response == null ||
        response.data == null ||
        response.data is! Map ||
        !(response.data as Map).containsKey('error')) {
      return null;
    }

    return ReCase((response.data as Map)['error']).snakeCase;
  }
}
