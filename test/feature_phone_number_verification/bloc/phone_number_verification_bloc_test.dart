import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('PhoneNumberVerificationBloc tests', () {
    final _expectedFullBlocOutput = <BlocOutput>[];

    final _mockPhoneRepository = MockPhoneRepository();
    final _mockLocalSettingsRepository = MockLocalSettingsRepository();
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    BlocTester<PhoneNumberVerificationBloc> _blocTester;
    PhoneNumberVerificationBloc _subject;

    setUp(() {
      reset(_mockPhoneRepository);
      _expectedFullBlocOutput.clear();

      _subject = PhoneNumberVerificationBloc(
        _mockPhoneRepository,
        _mockLocalSettingsRepository,
        _mockExceptionToMessageMapper,
      );
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester
          .assertCurrentState(PhoneNumberVerificationUninitializedState());
    });

    test('verifyPhone success', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenAnswer((_) => Future.value());

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      verify(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .called(1);

      verify(_mockLocalSettingsRepository.setUserVerified(isVerified: true))
          .called(1);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerifiedEvent(),
        PhoneNumberVerifiedState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone phoneIsAlreadyVerified service exception ', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(const ServiceException(
              ServiceExceptionType.phoneIsAlreadyVerified));

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationAlreadyVerifiedErrorEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone verificationCodeDoesNotExist service exception ',
        () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(const ServiceException(
              ServiceExceptionType.verificationCodeDoesNotExist));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.phoneNumberVerificationInvalidCodeError);

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationErrorState(
            errorMessage:
                LocalizedStrings.phoneNumberVerificationInvalidCodeError)
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone verificationCodeExpired service exception ', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(const ServiceException(
              ServiceExceptionType.verificationCodeExpired));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.phoneNumberVerificationExpiredCodeError);

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationErrorState(
            errorMessage:
                LocalizedStrings.phoneNumberVerificationExpiredCodeError)
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone service exception ', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(const ServiceException(
              ServiceExceptionType.customerProfileDoesNotExist));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.defaultGenericError);

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationErrorState(
            errorMessage: LocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone phoneAlreadyExists service exception ', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(
              const ServiceException(ServiceExceptionType.phoneAlreadyExists));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStrings.phoneAlreadyExistsError);

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationErrorState(
            errorMessage: LocalizedStrings.phoneAlreadyExistsError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('verifyPhone network error', () async {
      when(_mockPhoneRepository.verifyPhone(
              verificationCode: TestConstants.stubPhoneVerificationCode))
          .thenThrow(NetworkException());

      await _subject.verify(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      _expectedFullBlocOutput.addAll([
        PhoneNumberVerificationUninitializedState(),
        PhoneNumberVerificationLoadingState(),
        PhoneNumberVerificationNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
