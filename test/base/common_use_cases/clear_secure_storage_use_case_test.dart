import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/clear_secure_storage_use_case.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

void main() {
  final SecureStore _mockSecureStore = MockSecureStore();

  ClearSecureStorageUseCase _subject;

  setUp(() {
    reset(_mockSecureStore);
    _subject = ClearSecureStorageUseCase(_mockSecureStore);
  });

  test('execute', () async {
    await _subject.execute();

    verify(_mockSecureStore.deleteAll()).called(1);
  });
}
