import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';

void main() {
  group('TokenRepository tests', () {
    final SecureStore mockSecureStore = MockSecureStore();
    const stubToken = '123';

    setUp(() {
      reset(mockSecureStore);
    });

    test('get login token', () async {
      when(mockSecureStore.read(key: anyNamed('key')))
          .thenAnswer((_) => Future.value(stubToken));

      final subject = TokenRepository(mockSecureStore);

      final actualToken = await subject.getLoginToken();

      expect(actualToken, stubToken);

      verify(mockSecureStore.read(key: SecureStoreKeys.loginToken)).called(1);
    });

    test('set login token', () async {
      final subject = TokenRepository(mockSecureStore);

      await subject.setLoginToken(stubToken);

      verify(mockSecureStore.write(
              key: SecureStoreKeys.loginToken, value: stubToken))
          .called(1);
    });

    test('delete login token', () async {
      when(mockSecureStore.delete(key: anyNamed('key')))
          .thenAnswer((_) => Future.value());

      final subject = TokenRepository(mockSecureStore);

      await subject.deleteLoginToken();

      verify(mockSecureStore.delete(key: SecureStoreKeys.loginToken)).called(1);
    });
  });
}
