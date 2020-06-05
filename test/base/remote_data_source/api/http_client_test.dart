import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';

class TestInterceptor extends CustomInterceptor {}

void main() {
  group('HttpClient tests', () {
    test('constructor test', () {
      const stubBaseUrl = 'www.test.com';
      final stubInterceptor = TestInterceptor();
      final subject = HttpClient(
        stubBaseUrl,
        interceptors: [
          stubInterceptor,
          LogInterceptor(),
        ],
      );

      expect(subject.options.baseUrl, stubBaseUrl);
      expect(subject.interceptors, hasLength(2));
      expect(subject.interceptors[0], isInstanceOf<TestInterceptor>());
      expect(subject.interceptors[1], isInstanceOf<LogInterceptor>());
      expect(stubInterceptor.httpClient, subject);
    });
  });
}
