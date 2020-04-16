import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

final _mockLocalSettingsRepository = MockLocalSettingsRepository();
final _mockUserRepository = MockUserRepository();
final _mockSaveMobileSettingsUseCase = MockSaveMobileSettingsUseCase();
final _mockClearSecureStorageUseCase = MockClearSecureStorageUseCase();
final _mockRouteAuthenticationUseCase = MockRouteAuthenticationUseCase();

void main() {
  group('SplashBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<SplashBloc> blocTester;
    SplashBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockLocalSettingsRepository);
      reset(_mockUserRepository);
      reset(_mockSaveMobileSettingsUseCase);
      reset(_mockClearSecureStorageUseCase);
    });

    test('initialState', () {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject)
        ..assertCurrentState(SplashUninitializedState());
    });

    test('first use of the app', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.onboarding,
      );

      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashSuccessState(),
        SplashRedirectToTargetPageEvent(
            const RouteAuthenticationTarget(RouteAuthenticationPage.onboarding))
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user has seen onboarding, but hasn\'t loged in yet', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.welcome,
      );

      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashSuccessState(),
        SplashRedirectToTargetPageEvent(
            const RouteAuthenticationTarget(RouteAuthenticationPage.welcome))
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user has logged in previously, biometric auth fails', () async {
      final _mockBiometricBloc =
          MockBiometricBloc(BiometricUninitializedState());
      subject = _getSubjectWidget(mockBiometricBloc: _mockBiometricBloc);
      blocTester = BlocTester(subject);
      _when(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
        hasAcceptedBiometric: true,
      );

      when(_mockBiometricBloc.currentState)
          .thenReturn(BiometricAuthenticationFailedState());

      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashSuccessState(),
        SplashRedirectToTargetPageEvent(const RouteAuthenticationTarget(
            RouteAuthenticationPage.signInWithPin))
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('biometric auth succeeds', () async {
      final _mockBiometricBloc =
          MockBiometricBloc(BiometricUninitializedState());
      subject = _getSubjectWidget(mockBiometricBloc: _mockBiometricBloc);
      blocTester = BlocTester(subject);
      _when(
          email: TestConstants.stubEmail,
          password: TestConstants.stubPassword,
          hasAcceptedBiometric: true,
          authenticationPage: RouteAuthenticationPage.home);

      when(_mockBiometricBloc.currentState)
          .thenReturn(BiometricAuthenticationSuccessState());

      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashSuccessState(),
        SplashRedirectToTargetPageEvent(
            const RouteAuthenticationTarget(RouteAuthenticationPage.home))
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('first use of the app, getting mobile settings fails', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
      );
      when(_mockLocalSettingsRepository.getMobileSettings()).thenReturn(null);
      when(_mockSaveMobileSettingsUseCase.execute()).thenThrow(Exception());
      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('first use of the app, getting mobile settings fails', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
      );
      when(_mockLocalSettingsRepository.getMobileSettings()).thenReturn(null);
      when(_mockSaveMobileSettingsUseCase.execute())
          .thenThrow(NetworkException());
      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'consequent use of the app, getting mobile settings fails'
        'with non-network exception', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
      );

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(MockMobileSettings());
      when(_mockSaveMobileSettingsUseCase.execute()).thenThrow(Exception());
      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashRedirectToTargetPageEvent(const RouteAuthenticationTarget(
            RouteAuthenticationPage.signInWithPin))
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'consequent use of the app, getting mobile settings fails '
        'with network exception', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
      );

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(MockMobileSettings());
      when(_mockSaveMobileSettingsUseCase.execute())
          .thenThrow(NetworkException());
      await subject.initialize();
      expectedFullBlocOutput.addAll([
        SplashUninitializedState(),
        SplashLoadingState(),
        SplashNetworkErrorState()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('secure store is cleared on first run - isFirstRun true', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);

      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
        setIsFirstRun: true,
      );

      await subject.initialize();

      verify(_mockLocalSettingsRepository.setIsFirstRun(value: false))
          .called(1);

      verify(_mockClearSecureStorageUseCase.execute()).called(1);
    });

    test('secure store is cleared on first run - isFirstRun null', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
        setIsFirstRun: null,
      );

      await subject.initialize();

      verify(_mockLocalSettingsRepository.setIsFirstRun(value: false))
          .called(1);
      verify(_mockClearSecureStorageUseCase.execute()).called(1);
    });

    test('secure store not cleared on second run', () async {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
      _when(
        email: null,
        password: null,
        authenticationPage: RouteAuthenticationPage.signInWithPin,
        setIsFirstRun: false,
      );

      await subject.initialize();

      verifyNever(_mockLocalSettingsRepository.setIsFirstRun(value: false));
      verifyNever(_mockClearSecureStorageUseCase.execute());
    });
  });
}

void _when({
  @required String email,
  @required String password,
  @required RouteAuthenticationPage authenticationPage,
  bool hasAcceptedBiometric = false,
  bool setIsFirstRun = false,
}) {
  when(_mockUserRepository.getCustomerEmail())
      .thenAnswer((_) => Future.value(email));

  when(_mockUserRepository.getCustomerPassword())
      .thenAnswer((_) => Future.value(password));

  when(_mockRouteAuthenticationUseCase.execute(
          endPage: RouteAuthenticationPage.signInWithPin))
      .thenAnswer(
          (_) => Future.value(RouteAuthenticationTarget(authenticationPage)));

  when(_mockLocalSettingsRepository.getUserHasAcceptedBiometricAuthentication())
      .thenReturn(hasAcceptedBiometric);

  when(_mockLocalSettingsRepository.isFirstRun()).thenReturn(setIsFirstRun);
}

SplashBloc _getSubjectWidget({MockBiometricBloc mockBiometricBloc}) =>
    SplashBloc(
      _mockLocalSettingsRepository,
      mockBiometricBloc ?? MockBiometricBloc(BiometricUninitializedState()),
      _mockSaveMobileSettingsUseCase,
      _mockRouteAuthenticationUseCase,
      _mockClearSecureStorageUseCase,
    );
