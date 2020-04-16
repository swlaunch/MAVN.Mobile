import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('SetPhoneNumberBloc tests', () {
    final _mockPhoneRepository = MockPhoneRepository();
    final _expectedFullBlocOutput = <BlocOutput>[];
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    BlocTester<SetPhoneNumberBloc> _blocTester;
    SetPhoneNumberBloc _subject;

    setUp(() {
      reset(_mockPhoneRepository);
      _expectedFullBlocOutput.clear();

      _subject = SetPhoneNumberBloc(
          _mockPhoneRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(SetPhoneNumberUninitializedState());
    });

    test('setPhoneNumber success', () async {
      when(_mockPhoneRepository.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      )).thenAnswer((_) => Future.value());

      await _subject.setPhoneNumber(
          phoneNumber: TestConstants.stubPhoneNumber,
          countryPhoneCodeId: TestConstants.stubCountryCodeId);

      verify(_mockPhoneRepository.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      ));

      _expectedFullBlocOutput.addAll([
        SetPhoneNumberUninitializedState(),
        SetPhoneNumberLoadingState(),
        SetPhoneNumberEvent(),
        SetPhoneNumberSuccessState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('setPhoneNumber service exception ', () async {
      when(_mockPhoneRepository.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      )).thenThrow(const ServiceException(
          ServiceExceptionType.customerProfileDoesNotExist));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.defaultGenericError);

      await _subject.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      );

      _expectedFullBlocOutput.addAll([
        SetPhoneNumberUninitializedState(),
        SetPhoneNumberLoadingState(),
        SetPhoneNumberErrorState(
            errorMessage: LocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('setPhoneNumber phoneAlreadyExists service exception ', () async {
      when(_mockPhoneRepository.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.phoneAlreadyExists));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.phoneAlreadyExistsError);

      await _subject.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      );

      _expectedFullBlocOutput.addAll([
        SetPhoneNumberUninitializedState(),
        SetPhoneNumberLoadingState(),
        SetPhoneNumberInlineErrorState(
            errorMessage: LocalizedStrings.phoneAlreadyExistsError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('setPhoneNumber network error', () async {
      when(_mockPhoneRepository.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      )).thenThrow(NetworkException());

      await _subject.setPhoneNumber(
        phoneNumber: TestConstants.stubPhoneNumber,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
      );

      _expectedFullBlocOutput.addAll([
        SetPhoneNumberUninitializedState(),
        SetPhoneNumberLoadingState(),
        SetPhoneNumberNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
