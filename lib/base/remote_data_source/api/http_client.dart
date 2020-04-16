import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:lykke_mobile_mavn/app/app.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';

class HttpClient extends DioForNative {
  HttpClient(String baseUrl,
      {List<Interceptor> interceptors = const [],
      int timeoutSeconds = 30,
      SharedPreferencesManager sharedPreferencesManager}) {
    final timeoutMilliseconds = timeoutSeconds * 1000;

    options
      ..baseUrl = baseUrl
      ..connectTimeout = timeoutMilliseconds
      ..receiveTimeout = timeoutMilliseconds;

    print('WARNING: We are currently trusting all backend certificates. '
        'Please remove this soon.');
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // Hack to allow any incomplete certificates from the backend
      // TODO: Remove this when backend resolves certificates issue
      client.badCertificateCallback = (cert, host, port) =>
          App.environment == Environment.qa ||
          App.environment == Environment.dev;

      if (App.environment != Environment.staging &&
          App.environment != Environment.prod) {
        client.findProxy = (_) {
          final proxy = sharedPreferencesManager?.read(
              key: SharedPreferencesKeys.proxyUrl);

          return (proxy == null || proxy.isEmpty) ? 'DIRECT' : 'PROXY $proxy';
        };
      }
    };

    interceptors.forEach((interceptor) {
      if (interceptor is CustomInterceptor) {
        interceptor.httpClient = this;
      }
      this.interceptors.add(interceptor);
    });
  }
}

abstract class CustomInterceptor extends Interceptor {
  HttpClient httpClient;

  @override
  Future<dynamic> onRequest(RequestOptions options);

  @override
  Future<dynamic> onResponse(Response response);

  @override
  Future<dynamic> onError(DioError err);
}
