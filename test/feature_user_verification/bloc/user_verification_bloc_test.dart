import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_user_verification/bloc/user_verification_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../mock_classes.dart';

void main() {
  final _mockRouter = MockRouter();

  setUpAll(() {
    initScreenshots();
  });

  UserVerificationBloc _getSubject({
    bool hasBiometricsEnabled = false,
    bool canUseBiometrics = false,
    bool passesBiometrics = false,
    bool hasPinEnabled = false,
  }) {
    final mockLocalSettingsRepository = MockLocalSettingsRepository();
    final mockHasPinUseCase = MockHasPinUseCase();
    final mockBiometricBloc = MockBiometricBloc(passesBiometrics
        ? BiometricAuthenticationSuccessState()
        : BiometricAuthenticationFailedState());
    final mockLocalAuthentication = MockLocalAuthentication();

    when(mockLocalSettingsRepository
            .getUserHasAcceptedBiometricAuthentication())
        .thenReturn(hasBiometricsEnabled);

    when(mockLocalAuthentication.canCheckBiometrics)
        .thenAnswer((_) => Future.value(canUseBiometrics));

    when(mockHasPinUseCase.execute())
        .thenAnswer((_) => Future.value(hasPinEnabled));

    return UserVerificationBloc(
      mockBiometricBloc,
      _mockRouter,
      mockLocalSettingsRepository,
      mockHasPinUseCase,
      mockLocalAuthentication,
    );
  }

  group('User Verification Bloc tests', () {
    group('the user has enabled biometrics', () {
      testWidgets(
          'onSuccess should be invoked if '
          'biometrics verification has succeeded', (widgetTester) async {
        final subject = _getSubject(
          hasBiometricsEnabled: true,
          canUseBiometrics: true,
          passesBiometrics: true,
        );

        final mockFunctions = MockTestCallbacks();

        await subject.verify(
          onSuccess: mockFunctions.onSuccess,
          onFailure: mockFunctions.onFailure,
          onCouldNotVerify: mockFunctions.onCouldNotVerify,
        );

        verify(mockFunctions.onSuccess()).called(1);
        verifyNever(mockFunctions.onFailure());
        verifyNever(mockFunctions.onCouldNotVerify());
      });

      testWidgets(
          'onFailure should be invoked if '
          'biometrics verification has failed', (widgetTester) async {
        final subject = _getSubject(
          hasBiometricsEnabled: true,
          canUseBiometrics: true,
          passesBiometrics: false,
        );

        final mockFunctions = MockTestCallbacks();

        await subject.verify(
          onSuccess: mockFunctions.onSuccess,
          onFailure: mockFunctions.onFailure,
          onCouldNotVerify: mockFunctions.onCouldNotVerify,
        );

        verifyNever(mockFunctions.onSuccess());
        verify(mockFunctions.onFailure()).called(1);
        verifyNever(mockFunctions.onCouldNotVerify());
      });
    });

    group('the user has not enabled biometrics, but has a pin setup', () {
      testWidgets(
          'the application should navigate to the pin verification '
          'page', (widgetTester) async {
        final subject = _getSubject(
          hasBiometricsEnabled: false,
          hasPinEnabled: true,
        );

        final mockFunctions = MockTestCallbacks();

        await subject.verify(
          onSuccess: mockFunctions.onSuccess,
          onFailure: mockFunctions.onFailure,
          onCouldNotVerify: mockFunctions.onCouldNotVerify,
        );

        verify(_mockRouter.pushPinVerificationPage()).called(1);
        verifyNever(mockFunctions.onCouldNotVerify());
      });
    });

    group(
        'the user has not enabled biometrics, '
        'and does not have a pin setup', () {
      testWidgets('onCouldNotVerify should be invoked', (widgetTester) async {
        final subject = _getSubject(
          hasBiometricsEnabled: false,
          hasPinEnabled: false,
        );

        final mockFunctions = MockTestCallbacks();

        await subject.verify(
          onSuccess: mockFunctions.onSuccess,
          onFailure: mockFunctions.onFailure,
          onCouldNotVerify: mockFunctions.onCouldNotVerify,
        );

        verifyNever(mockFunctions.onSuccess());
        verifyNever(mockFunctions.onFailure());
        verify(mockFunctions.onCouldNotVerify()).called(1);
      });
    });
  });
}

class MockTestCallbacks extends Mock implements TestCallbacks {}

class TestCallbacks {
  // ignore: always_declare_return_types
  onSuccess() {}

  // ignore: always_declare_return_types
  onFailure() {}

  // ignore: always_declare_return_types
  onCouldNotVerify() {}
}
