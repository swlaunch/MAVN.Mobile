import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

void main() {
  group('PhoneVerificationGenerationBloc tests', () {
    final _mockPhoneRepository = MockPhoneRepository();
    final _expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<PhoneVerificationGenerationBloc> _blocTester;
    PhoneVerificationGenerationBloc _subject;

    setUp(() {
      reset(_mockPhoneRepository);
      _expectedFullBlocOutput.clear();

      _subject = PhoneVerificationGenerationBloc(_mockPhoneRepository);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester
          .assertCurrentState(PhoneVerificationGenerationUninitializedState());
    });

    test('sendVerification success', () async {
      when(_mockPhoneRepository.sendVerification())
          .thenAnswer((_) => Future.value());

      await _subject.sendVerificationMessage();

      verify(_mockPhoneRepository.sendVerification());

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationSentSmsEvent(),
        PhoneVerificationGenerationSuccessState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification already verified service exception ', () async {
      when(_mockPhoneRepository.sendVerification()).thenThrow(
          const ServiceException(ServiceExceptionType.phoneIsAlreadyVerified));

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationAlreadyVerifiedErrorEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification reached max requests service exception ', () async {
      when(_mockPhoneRepository.sendVerification()).thenThrow(
          const ServiceException(
              ServiceExceptionType.reachedMaximumRequestForPeriod));

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationErrorState(
            errorMessage:
                LocalizedStrings.emailVerificationExceededMaxAttemptsError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification reached max requests service exception ', () async {
      when(_mockPhoneRepository.sendVerification()).thenThrow(
          const ServiceException(
              ServiceExceptionType.reachedMaximumRequestForPeriod));

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationErrorState(
            errorMessage:
                LocalizedStrings.emailVerificationExceededMaxAttemptsError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification irrelevant service exception ', () async {
      when(_mockPhoneRepository.sendVerification()).thenThrow(
          const ServiceException(
              ServiceExceptionType.customerProfileDoesNotExist));

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationErrorState(
            errorMessage:
                LocalizedStrings.phoneNumberVerificationCodeNotSentError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification unknown exception ', () async {
      when(_mockPhoneRepository.sendVerification()).thenThrow(Exception());

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationErrorState(
            errorMessage:
                LocalizedStrings.phoneNumberVerificationCodeNotSentError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerification network error', () async {
      when(_mockPhoneRepository.sendVerification())
          .thenThrow(NetworkException());

      await _subject.sendVerificationMessage();

      _expectedFullBlocOutput.addAll([
        PhoneVerificationGenerationUninitializedState(),
        PhoneVerificationGenerationLoadingState(),
        PhoneVerificationGenerationNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
