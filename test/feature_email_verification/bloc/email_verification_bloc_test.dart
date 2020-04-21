import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockEmailRepository = MockEmailRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<EmailVerificationBloc> _blocTester = BlocTester(
    EmailVerificationBloc(_mockEmailRepository, _mockExceptionToMessageMapper));

EmailVerificationBloc _subject;

void main() {
  group('EmailVerificationBlocTests', () {
    setUp(() {
      reset(_mockEmailRepository);
      _expectedFullBlocOutput.clear();

      _subject = EmailVerificationBloc(
          _mockEmailRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(EmailVerificationUninitializedState());
    });

    test('submitEmailVerification success', () async {
      await _subject.sendVerificationEmail();

      expect(
        verify(_mockEmailRepository.sendVerificationEmail()).callCount,
        1,
      );
      _expectedFullBlocOutput.addAll([
        EmailVerificationUninitializedState(),
        EmailVerificationLoadingState(),
        EmailVerificationSuccessState()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('sendVerificationEmail generic error', () async {
      when(_mockEmailRepository.sendVerificationEmail()).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.sendVerificationEmail();

      _expectedFullBlocOutput.addAll([
        EmailVerificationUninitializedState(),
        EmailVerificationLoadingState(),
        EmailVerificationErrorState(
            error: LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerificationEmail network error', () async {
      when(_mockEmailRepository.sendVerificationEmail())
          .thenThrow(NetworkException());

      await _subject.sendVerificationEmail();

      _expectedFullBlocOutput.addAll([
        EmailVerificationUninitializedState(),
        EmailVerificationLoadingState(),
        EmailVerificationNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerificationEmail already verified', () async {
      when(_mockEmailRepository.sendVerificationEmail()).thenThrow(
          const ServiceException(ServiceExceptionType.emailIsAlreadyVerified,
              message: TestConstants.stubErrorText));

      await _subject.sendVerificationEmail();

      _expectedFullBlocOutput.addAll([
        EmailVerificationUninitializedState(),
        EmailVerificationLoadingState(),
        EmailVerificationAlreadyVerifiedEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('sendVerificationEmail reached max attempts error', () async {
      when(_mockEmailRepository.sendVerificationEmail()).thenThrow(
          const ServiceException(
              ServiceExceptionType.reachedMaximumRequestForPeriod,
              message: TestConstants.stubErrorText));

      await _subject.sendVerificationEmail();

      _expectedFullBlocOutput.addAll([
        EmailVerificationUninitializedState(),
        EmailVerificationLoadingState(),
        EmailVerificationErrorState(
            error:
                LazyLocalizedStrings.emailVerificationExceededMaxAttemptsError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
