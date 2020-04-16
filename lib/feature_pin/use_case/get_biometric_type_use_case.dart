import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class GetBiometricTypeUseCase {
  GetBiometricTypeUseCase(
    this.localAuthentication, {
    this.isIOS,
  });

  final LocalAuthentication localAuthentication;
  final bool isIOS;

  Future<BiometricType> execute() async {
    if (isIOS) {
      final availableBiometrics =
          await localAuthentication.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return null;
      }

      if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricType.fingerprint;
      }
    }

    return BiometricType.fingerprint;
  }
}

GetBiometricTypeUseCase useGetBiometricTypeUseCase() =>
    ModuleProvider.of<PinModule>(useContext()).getBiometricTypeUseCase;
