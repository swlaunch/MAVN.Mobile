import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/error_codes.dart' as auth_error_codes;
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

final _mockLocalSettingsRepository = MockLocalSettingsRepository();
final _mockUserRepository = MockUserRepository();
final _mockLocalAuthentication = MockLocalAuthentication();
final _localizedStrings = LocalizedStrings();

void main() {
  group('BiometricBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<BiometricBloc> blocTester;
    BiometricBloc subject;

    setUp(() {
      reset(_mockLocalSettingsRepository);
      reset(_mockUserRepository);
      reset(_mockLocalAuthentication);

      expectedFullBlocOutput.clear();
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      subject = _getSubjectWidget();
      blocTester = BlocTester(subject)
        ..assertCurrentState(BiometricUninitializedState());
    });

    test('no biometric capabilities', () async {
      _when(canCheckBiometrics: false, hasBeenPreviouslyLoggedIn: false);

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricCannotAuthenticateState(),
        BiometricAuthenticationWillNotAuthenticateEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'no biometric permission data -> user will be asked for permission '
        'scenario first time using the app', () async {
      _when(canCheckBiometrics: true, hasBeenPreviouslyLoggedIn: false);

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricRequirePermissionState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('biometrics previously rejected -> user will be asked for permission ',
        () async {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: false,
          countRejections: 1,
          latRejected: yesterday,
          hasBeenPreviouslyLoggedIn: false);
      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricRequirePermissionState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('rejected 3 times -> user will NOT be asked for permission ',
        () async {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: false,
          countRejections: 3,
          latRejected: yesterday,
          hasBeenPreviouslyLoggedIn: false);

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricCannotAuthenticateState(),
        BiometricAuthenticationWillNotAuthenticateEvent()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user was asked today -> user will NOT be asked for permission ',
        () async {
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: false,
          countRejections: 1,
          latRejected: DateTime.now(),
          hasBeenPreviouslyLoggedIn: false);

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricCannotAuthenticateState(),
        BiometricAuthenticationWillNotAuthenticateEvent()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user has enabled biometrics but hasn\'t logged in previously',
        () async {
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: true,
          hasBeenPreviouslyLoggedIn: false);

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticatingState(),
        BiometricAuthenticationFailedState(),
        BiometricAuthenticationFailedEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user has enabled biometrics but hasn\'t authenticated successfully',
        () async {
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: true,
          hasBeenPreviouslyLoggedIn: true);
      when(
        _mockLocalAuthentication.authenticateWithBiometrics(
          localizedReason:
              _localizedStrings.biometricAuthenticationPromptMessage,
          androidAuthStrings: anyNamed('androidAuthStrings'),
          stickyAuth: true,
        ),
      ).thenAnswer((_) => Future.value(false));

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticatingState(),
        BiometricAuthenticationFailedState(),
        BiometricAuthenticationFailedEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('user has enabled biometrics but there was a problem authenticating',
        () async {
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: true,
          hasBeenPreviouslyLoggedIn: true);
      when(
        _mockLocalAuthentication.authenticateWithBiometrics(
          localizedReason:
              _localizedStrings.biometricAuthenticationPromptMessage,
          androidAuthStrings: anyNamed('androidAuthStrings'),
          stickyAuth: true,
        ),
      ).thenThrow(PlatformException(code: auth_error_codes.lockedOut));

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticatingState(),
        BiometricCannotAuthenticateState(),
        BiometricAuthenticationWillNotAuthenticateEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('authenticatin succeeds, logging in fails', () async {
      final _mockLoginBloc = MockLoginBloc(LoginUninitializedState());

      subject = _getSubjectWidget(mockLoginBloc: _mockLoginBloc);
      blocTester = BlocTester(subject);
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: true,
          hasBeenPreviouslyLoggedIn: true);
      when(
        _mockLocalAuthentication.authenticateWithBiometrics(
          localizedReason:
              _localizedStrings.biometricAuthenticationPromptMessage,
          androidAuthStrings: anyNamed('androidAuthStrings'),
          stickyAuth: true,
        ),
      ).thenAnswer((_) => Future.value(true));

      when(_mockLoginBloc.currentState).thenReturn(LoginErrorState(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticatingState(),
        BiometricAuthenticationFailedState(),
        BiometricAuthenticationFailedEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('happy path: authenticatin succeeds, logging in succeed', () async {
      final _mockLoginBloc = MockLoginBloc(LoginUninitializedState());

      subject = _getSubjectWidget(mockLoginBloc: _mockLoginBloc);
      blocTester = BlocTester(subject);
      _when(
          canCheckBiometrics: true,
          hasAcceptedBiometrics: true,
          hasBeenPreviouslyLoggedIn: true);
      when(
        _mockLocalAuthentication.authenticateWithBiometrics(
          localizedReason:
              _localizedStrings.biometricAuthenticationPromptMessage,
          androidAuthStrings: anyNamed('androidAuthStrings'),
          stickyAuth: true,
        ),
      ).thenAnswer((_) => Future.value(true));

      when(_mockLoginBloc.currentState).thenReturn(LoginSuccessState());

      await subject.tryUsingBiometricAuthentication();

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticatingState(),
        BiometricAuthenticationSuccessState(),
        BiometricAuthenticationSuccessEvent(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('isBiometricEnabled - disabled from app settings', () async {
      when(_mockLocalSettingsRepository
              .getUserHasAcceptedBiometricAuthentication())
          .thenReturn(false);

      expect(await subject.isBiometricEnabled, false);
    });

    test('isBiometricEnabled - enabled from app settings, enabled from device',
        () async {
      when(_mockLocalSettingsRepository
              .getUserHasAcceptedBiometricAuthentication())
          .thenReturn(true);

      when(_mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([BiometricType.face]));

      expect(await subject.isBiometricEnabled, true);
    });

    test('isBiometricEnabled - enabled from app settings, disabled from device',
        () async {
      when(_mockLocalSettingsRepository
              .getUserHasAcceptedBiometricAuthentication())
          .thenReturn(true);

      when(_mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([]));

      expect(await subject.isBiometricEnabled, false);
    });

    test('toggleBiometric - disable', () async {
      await subject.toggleBiometrics(enable: false);

      verify(await _mockLocalSettingsRepository
              .setUserHasAcceptedBiometricAuthentication(accepted: false))
          .called(1);
    });

    test('toggleBiometric - enable - disabled biometrics from device level',
        () async {
      when(_mockLocalAuthentication.canCheckBiometrics)
          .thenAnswer((_) => Future.value(false));

      final result = await subject.toggleBiometrics(enable: true);

      expectedFullBlocOutput.addAll([
        BiometricUninitializedState(),
        BiometricAuthenticationDisabledEvent()
      ]);

      expect(result, false);
      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('toggleBiometric - enable - to enabled biometrics from device level',
        () async {
      when(_mockLocalAuthentication.canCheckBiometrics)
          .thenAnswer((_) => Future.value(true));

      when(_mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([]));

      final result = await subject.toggleBiometrics(enable: true);

      verify(await _mockLocalSettingsRepository
              .setUserHasAcceptedBiometricAuthentication(accepted: true))
          .called(1);

      expect(result, true);
    });

    test('toggleBiometric - enable - enabled biometrics from device level',
        () async {
      when(_mockLocalAuthentication.canCheckBiometrics)
          .thenAnswer((_) => Future.value(true));

      when(_mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([BiometricType.face]));

      final result = await subject.toggleBiometrics(enable: true);

      expect(result, true);

      verify(await _mockLocalSettingsRepository
              .setUserHasAcceptedBiometricAuthentication(accepted: true))
          .called(1);
    });
  });
}

void _when(
    {bool canCheckBiometrics,
    bool hasAcceptedBiometrics,
    int countRejections,
    DateTime latRejected,
    bool hasBeenPreviouslyLoggedIn}) {
  when(_mockLocalAuthentication.canCheckBiometrics)
      .thenAnswer((_) => Future.value(canCheckBiometrics));

  when(_mockLocalSettingsRepository.getUserHasAcceptedBiometricAuthentication())
      .thenReturn(hasAcceptedBiometrics ?? false);

  when(_mockLocalSettingsRepository.getCountBiometricRejections())
      .thenReturn(countRejections);

  when(_mockLocalSettingsRepository.getLastBiometricRejectionTimeStamp())
      .thenReturn(latRejected?.millisecondsSinceEpoch);

  when(_mockUserRepository.hasBeenPreviouslyLoggedIn())
      .thenAnswer((_) => Future.value(hasBeenPreviouslyLoggedIn));
}

BiometricBloc _getSubjectWidget({MockLoginBloc mockLoginBloc}) => BiometricBloc(
    _mockLocalSettingsRepository,
    _mockLocalAuthentication,
    _mockUserRepository,
    mockLoginBloc ?? MockLoginBloc(LoginUninitializedState()))
  ..localizedStrings = _localizedStrings;
