import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/token_interceptor.dart';
import 'package:mockito/mockito.dart';

import '../../../../mock_classes.dart';

void main() {
  group('Token inteceptor tests', () {
    final mockTokenRepository = MockTokenRepository();

    test('onRequest test', () async {
      const stubToken = '123';

      final stubRequestOptions = RequestOptions();

      when(mockTokenRepository.getLoginToken())
          .thenAnswer((_) => Future<String>.value(stubToken));

      final subject = TokenInterceptor(mockTokenRepository);
      final actualRequestOptions = await subject.onRequest(stubRequestOptions);

      expect(
          actualRequestOptions.headers['authorization'], 'Bearer $stubToken');
    });
  });
}
