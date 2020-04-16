import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/feature_pin/use_case/get_biometric_type_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

void main() {
  group('Biometric type use case tests', () {
    final LocalAuthentication mockLocalAuthentication =
        MockLocalAuthentication();

    test('not enabled biometrics - iOS', () async {
      when(mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([]));

      final subject =
          GetBiometricTypeUseCase(mockLocalAuthentication, isIOS: true);

      final type = await subject.execute();

      expect(type, null);

      verify(mockLocalAuthentication.getAvailableBiometrics()).called(1);
    });

    test('face id - iOS', () async {
      when(mockLocalAuthentication.getAvailableBiometrics()).thenAnswer(
          (_) => Future.value([BiometricType.face, BiometricType.fingerprint]));

      final subject =
          GetBiometricTypeUseCase(mockLocalAuthentication, isIOS: true);

      final type = await subject.execute();

      expect(type, BiometricType.face);

      verify(mockLocalAuthentication.getAvailableBiometrics()).called(1);
    });

    test('fingerprint - iOS', () async {
      when(mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([BiometricType.fingerprint]));

      final subject =
          GetBiometricTypeUseCase(mockLocalAuthentication, isIOS: true);

      final type = await subject.execute();

      expect(type, BiometricType.fingerprint);

      verify(mockLocalAuthentication.getAvailableBiometrics()).called(1);
    });

    test('fingerprint - Android', () async {
      when(mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) => Future.value([BiometricType.fingerprint]));

      final subject =
          GetBiometricTypeUseCase(mockLocalAuthentication, isIOS: false);

      final type = await subject.execute();

      expect(type, BiometricType.fingerprint);

      verifyNever(mockLocalAuthentication.getAvailableBiometrics());
    });
  });
}
