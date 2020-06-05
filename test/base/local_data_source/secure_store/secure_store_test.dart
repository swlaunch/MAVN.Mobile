import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';

void main() {
  group('SecureStore tests', () {
    final mockFlutterSecureStorage = MockFlutterSecureStorage();
    const stubKey = 'stubKey';
    const stubValue = '123';

    setUp(() {
      reset(mockFlutterSecureStorage);
    });

    test('read', () async {
      when(mockFlutterSecureStorage.read(key: stubKey))
          .thenAnswer((_) => Future.value(stubValue));

      final subject = SecureStore(mockFlutterSecureStorage);

      final readResult = await subject.read(key: stubKey);

      expect(readResult, stubValue);
      verify(mockFlutterSecureStorage.read(key: stubKey)).called(1);
    });

    test('write', () async {
      final subject = SecureStore(mockFlutterSecureStorage);

      await subject.write(key: stubKey, value: stubValue);

      verify(mockFlutterSecureStorage.write(key: stubKey, value: stubValue))
          .called(1);
    });

    test('delete single entry', () async {
      final subject = SecureStore(mockFlutterSecureStorage);

      await subject.delete(key: stubKey);

      verify(mockFlutterSecureStorage.delete(key: stubKey)).called(1);
    });

    test('delete all entries', () async {
      final subject = SecureStore(mockFlutterSecureStorage);

      await subject.deleteAll();

      verify(mockFlutterSecureStorage.deleteAll()).called(1);
    });
  });
}
