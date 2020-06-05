import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';

void main() {
  group('UserRepository tests', () {
    final SecureStore mockSecureStore = MockSecureStore();
    const stubEmail = 'stubEmail';

    setUp(() {
      reset(mockSecureStore);
    });

    test('get user email', () async {
      when(mockSecureStore.read(key: anyNamed('key')))
          .thenAnswer((_) => Future.value(stubEmail));

      final subject = UserRepository(mockSecureStore);

      final actualEmail = await subject.getCustomerEmail();

      expect(actualEmail, stubEmail);

      verify(mockSecureStore.read(key: SecureStoreKeys.customerEmail))
          .called(1);
    });

    test('set user email', () async {
      final subject = UserRepository(mockSecureStore);

      await subject.setCustomerEmail(stubEmail);

      verify(mockSecureStore.write(
              key: SecureStoreKeys.customerEmail, value: stubEmail))
          .called(1);
    });
  });
}
