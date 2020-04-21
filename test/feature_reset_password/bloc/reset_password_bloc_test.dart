import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

void main() {
  group('ResetPasswordBloc tests', () {
    final mockCustomerRepository = MockCustomerRepository();
    final mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<ResetPasswordBloc> blocTester;
    ResetPasswordBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();
      subject = ResetPasswordBloc(
          mockCustomerRepository, mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(ResetPasswordUninitializedState());
    });

    test('sendLink success', () async {
      when(mockCustomerRepository.generateResetPasswordLink(email: ''))
          .thenAnswer((_) => Future.value(null));

      await subject.sendLink('');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordSentEmailState(),
        ResetPasswordSentEmailEvent()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('sendLink connectivity error', () async {
      when(mockCustomerRepository.generateResetPasswordLink(email: ''))
          .thenThrow(NetworkException());

      when(mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await subject.sendLink('');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordErrorState(
            errorMessage: LazyLocalizedStrings.networkError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('sendLink generic error', () async {
      when(mockCustomerRepository.generateResetPasswordLink(email: ''))
          .thenThrow(Exception());

      when(mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.sendLink('');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordErrorState(
            errorMessage: LazyLocalizedStrings.defaultGenericError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    //////////

    test('resetPassword success', () async {
      when(mockCustomerRepository.resetPassword(
              password: '', resetIdentifier: '', email: ''))
          .thenAnswer((_) => Future.value(null));

      await subject.changePassword(
          email: '', resetIdentifier: '', password: '');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordChangedState(),
        ResetPasswordChangedEvent()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('resetPassword connectivity error', () async {
      when(mockCustomerRepository.resetPassword(
              password: '', resetIdentifier: '', email: ''))
          .thenThrow(NetworkException());

      when(mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await subject.changePassword(
          email: '', resetIdentifier: '', password: '');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordErrorState(
            errorMessage: LazyLocalizedStrings.networkError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('resetPassword generic error', () async {
      when(mockCustomerRepository.resetPassword(
              password: '', resetIdentifier: '', email: ''))
          .thenThrow(Exception());

      when(mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.changePassword(
          email: '', resetIdentifier: '', password: '');

      expectedFullBlocOutput.addAll([
        ResetPasswordUninitializedState(),
        ResetPasswordLoadingState(),
        ResetPasswordErrorState(
            errorMessage: LazyLocalizedStrings.defaultGenericError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
