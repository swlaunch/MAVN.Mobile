import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('RegisterBloc tests', () {
    final _mockRegisterUseCase = MockRegisterUseCase();
    final _expectedFullBlocOutput = <BlocOutput>[];
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    BlocTester<RegisterBloc> _blocTester;
    RegisterBloc _subject;

    setUp(() {
      reset(_mockRegisterUseCase);
      _expectedFullBlocOutput.clear();

      _subject =
          RegisterBloc(_mockRegisterUseCase, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(RegisterUninitializedState());
    });

    test('register success', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenAnswer((_) => Future.value());

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      verify(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      ));

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterSuccessEvent(
            registrationEmail: TestConstants.stubEmailLowercase)
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('register exception from incorrect email', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.invalidEmailFormat));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStringBuilder.custom('Invalid email'));

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(LocalizedStringBuilder.custom('Invalid email')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('register exception from incorrect password', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.invalidPasswordFormat));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStringBuilder.custom('Invalid password'));

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(LocalizedStringBuilder.custom('Invalid password')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('register exception from login already in use', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.loginAlreadyInUse));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LocalizedStringBuilder.custom('Login already in use'));

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(
            LocalizedStringBuilder.custom('Login already in use')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('register exception from email is not allowed', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.emailIsNotAllowed));

      when(_mockExceptionToMessageMapper.map(
              const ServiceException(ServiceExceptionType.emailIsNotAllowed)))
          .thenReturn(
              LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('register exception from connectivity issues', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(LazyLocalizedStrings.networkError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('unknown register exception', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(
          const ServiceException(ServiceExceptionType.invalidCredentials));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('unhandled register exception', () async {
      when(_mockRegisterUseCase.execute(
        email: TestConstants.stubEmailLowercase,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      _expectedFullBlocOutput.addAll([
        RegisterUninitializedState(),
        RegisterLoadingState(),
        RegisterErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
