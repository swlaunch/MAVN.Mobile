import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/delete_account_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('DeleteAccountUseCase tests', () {
    final _mockCustomerRepository = MockCustomerRepository();
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    DeleteAccountUseCase _subject;

    setUp(() {
      _subject = DeleteAccountUseCase(
          _mockCustomerRepository, _mockExceptionToMessageMapper);
    });

    test('success path', () async {
      when(_mockCustomerRepository.deleteAccount())
          .thenAnswer((_) => Future.value());

      await _subject.execute();

      verify(_mockCustomerRepository.deleteAccount()).called(1);
    });

    test('error path', () async {
      when(_mockCustomerRepository.deleteAccount()).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      expect(
          () => _subject.execute(),
          throwsA(CustomException(
              LocalizedStringBuilder.custom(TestConstants.stubErrorText))));
    });
  });
}
