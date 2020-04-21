import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_change_password/use_case/change_password_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

ChangePasswordUseCase mockChangePasswordUseCase = MockChangePasswordUseCase();
MockChangePasswordAnalyticsManager _mockChangePasswordAnalyticsManager;
final _mockUserRepository = MockUserRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

List<BlocOutput> expectedFullBlocOutput = [];

BlocTester<ChangePasswordBloc> blocTester;
ChangePasswordBloc subject;

void main() {
  group('ChangePasswordBloc tests', () {
    setUp(() {
      reset(mockChangePasswordUseCase);
      _mockChangePasswordAnalyticsManager =
          MockChangePasswordAnalyticsManager();
      expectedFullBlocOutput.clear();

      subject = ChangePasswordBloc(
        mockChangePasswordUseCase,
        _mockChangePasswordAnalyticsManager,
        _mockUserRepository,
        _mockExceptionToMessageMapper,
      );
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(ChangePasswordUninitializedState());
    });

    test('changePassword success', () async {
      givenChangePasswordUseCaseExecuteWillSucceed();

      await subject.changePassword(password: TestConstants.stubPassword);

      expectedFullBlocOutput.addAll([
        ChangePasswordUninitializedState(),
        ChangePasswordLoadingState(),
        ChangePasswordSuccessEvent()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('change password exception invalid password', () async {
      givenChangePasswordUseCaseExecuteWillThrow(
          const ServiceException(ServiceExceptionType.invalidPasswordFormat));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LazyLocalizedStrings.registerPageBackendInvalidPasswordError);

      await subject.changePassword(password: TestConstants.stubPassword);

      expectedFullBlocOutput.addAll([
        ChangePasswordUninitializedState(),
        ChangePasswordLoadingState(),
        ChangePasswordInlineErrorState(
            LazyLocalizedStrings.registerPageBackendInvalidPasswordError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('change password exception network exception', () async {
      givenChangePasswordUseCaseExecuteWillThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await subject.changePassword(password: TestConstants.stubPassword);

      expectedFullBlocOutput.addAll([
        ChangePasswordUninitializedState(),
        ChangePasswordLoadingState(),
        ChangePasswordErrorState(LazyLocalizedStrings.networkError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('unhandled changePassword exception', () async {
      givenChangePasswordUseCaseExecuteWillThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.changePassword(password: TestConstants.stubPassword);

      expectedFullBlocOutput.addAll([
        ChangePasswordUninitializedState(),
        ChangePasswordLoadingState(),
        ChangePasswordErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}

void givenChangePasswordUseCaseExecuteWillSucceed() {
  when(mockChangePasswordUseCase.execute(TestConstants.stubPassword))
      .thenAnswer((_) => Future.value());
}

void givenChangePasswordUseCaseExecuteWillThrow(Exception e) {
  when(mockChangePasswordUseCase.execute(TestConstants.stubPassword))
      .thenThrow(e);
}
