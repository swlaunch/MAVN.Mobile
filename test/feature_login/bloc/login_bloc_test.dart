import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockLoginUseCase = MockLoginUseCase();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<LoginBloc> _blocTester;
LoginBloc _subject;

void main() {
  group('LoginBloc tests', () {
    setUp(() {
      reset(_mockLoginUseCase);
      _expectedFullBlocOutput.clear();

      _subject = LoginBloc(_mockLoginUseCase, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(LoginUninitializedState());
    });

    test('login success', () async {
      givenLoginUseCaseExecuteWillSucceed();

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      verify(_mockLoginUseCase.execute(
          TestConstants.stubEmailLowercase, TestConstants.stubPassword));

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginSuccessState(),
        LoginSuccessEvent(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('login exception from incorrect email', () async {
      givenLoginUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.invalidEmailFormat));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(
              'Your login details are incorrect. Please try again.'));

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LocalizedStringBuilder.custom(
            'Your login details are incorrect. Please try again.')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('login exception from incorrect password', () async {
      givenLoginUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.invalidPasswordFormat));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(
              'Your login details are incorrect. Please try again.'));

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LocalizedStringBuilder.custom(
            'Your login details are incorrect. Please try again.')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('login exception from invalid credentials', () async {
      givenLoginUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.invalidCredentials));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(
              'Your login details are incorrect. Please try again.'));

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LocalizedStringBuilder.custom(
            'Your login details are incorrect. Please try again.')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('login exception from connectivity issues', () async {
      givenLoginUseCaseExecuteWillThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LazyLocalizedStrings.networkError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('unknown login exception', () async {
      givenLoginUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.loginAlreadyInUse));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('unhandled login exception', () async {
      givenLoginUseCaseExecuteWillThrow(Exception());

      when(_mockExceptionToMessageMapper.map(null))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('customer is blocked', () async {
      givenLoginUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.customerBlocked));

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorDeactivatedAccountEvent()
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('too many attempts exception', () async {
      givenLoginUseCaseExecuteWillThrow(const TooManyRequestException(
          ServiceExceptionType.tooManyLoginRequest,
          message: 'message',
          retryPeriodInMinutes: 3));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.loginPageTooManyRequestMessage(3));

      await _subject.login(TestConstants.stubEmail, TestConstants.stubPassword);

      _expectedFullBlocOutput.addAll([
        LoginUninitializedState(),
        LoginLoadingState(),
        LoginErrorState(LazyLocalizedStrings.loginPageTooManyRequestMessage(3))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}

void givenLoginUseCaseExecuteWillSucceed() {
  when(_mockLoginUseCase.execute(
          TestConstants.stubEmailLowercase, TestConstants.stubPassword))
      .thenAnswer((_) => Future.value());
}

void givenLoginUseCaseExecuteWillThrow(Exception e) {
  when(_mockLoginUseCase.execute(
          TestConstants.stubEmailLowercase, TestConstants.stubPassword))
      .thenThrow(e);
}
