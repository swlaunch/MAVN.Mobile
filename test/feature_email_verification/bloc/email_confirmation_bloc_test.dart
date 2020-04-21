import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

const verificationCode = '123qwe456tyu';
List<BlocOutput> _expectedFullBlocOutput = [];

final _mockEmailRepository = MockEmailRepository();
final _mockLocalSettingsRepository = MockLocalSettingsRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<EmailConfirmationBloc> _blocTester = BlocTester(
    EmailConfirmationBloc(_mockEmailRepository, _mockLocalSettingsRepository,
        _mockExceptionToMessageMapper));

EmailConfirmationBloc _subject;

void main() {
  group('EmailConfirmationBlocTests', () {
    setUp(() {
      reset(_mockEmailRepository);
      _expectedFullBlocOutput.clear();
      when(_mockLocalSettingsRepository.getEmailVerificationCode())
          .thenReturn(verificationCode);
      _subject = EmailConfirmationBloc(_mockEmailRepository,
          _mockLocalSettingsRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(EmailConfirmationUninitializedState());
    });

    test('confirmEmail success', () async {
      await _subject.confirmEmail();

      verify(_mockEmailRepository.verifyEmail(
              verificationCode: verificationCode))
          .called(1);

      verify(_mockLocalSettingsRepository.removeEmailVerificationCode())
          .called(1);

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationLoadingState(),
        EmailConfirmationSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('confirmEmail generic error', () async {
      when(_mockEmailRepository.verifyEmail(
              verificationCode: anyNamed('verificationCode')))
          .thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.confirmEmail();

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationLoadingState(),
        EmailConfirmationErrorState(
            error: LazyLocalizedStrings.defaultGenericError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('confirmEmail network error', () async {
      when(_mockEmailRepository.verifyEmail(
              verificationCode: anyNamed('verificationCode')))
          .thenThrow(NetworkException());

      await _subject.confirmEmail();

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationLoadingState(),
        EmailConfirmationNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('confirmEmail already verified', () async {
      when(_mockEmailRepository.verifyEmail(
              verificationCode: anyNamed('verificationCode')))
          .thenThrow(const ServiceException(
              ServiceExceptionType.emailIsAlreadyVerified,
              message: TestConstants.stubErrorText));

      await _subject.confirmEmail();

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationLoadingState(),
        EmailConfirmationAlreadyVerifiedEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('confirmEmail expired code', () async {
      when(_mockEmailRepository.verifyEmail(
              verificationCode: anyNamed('verificationCode')))
          .thenThrow(const ServiceException(
              ServiceExceptionType.verificationCodeExpired,
              message: TestConstants.stubErrorText));

      await _subject.confirmEmail();

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationLoadingState(),
        EmailConfirmationInvalidCodeEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('store code', () async {
      await _subject.storeVerificationCode(verificationCode);

      _expectedFullBlocOutput.addAll([
        EmailConfirmationUninitializedState(),
        EmailConfirmationStoredKey(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
