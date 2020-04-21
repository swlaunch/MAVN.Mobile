import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/use_case/get_biometric_type_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

GetBiometricTypeUseCase _mockGetBiometricTypeUseCase =
    MockGetBiometricTypeUseCase();

BlocTester<BiometricTypeBloc> _blocTester;
BiometricTypeBloc _subject;

void main() {
  group('BiometricTypeBloc tests', () {
    setUp(() {
      reset(_mockGetBiometricTypeUseCase);

      _subject = BiometricTypeBloc(_mockGetBiometricTypeUseCase);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(BiometricTypeUninitializedState());
    });

    test('fingerprint', () async {
      when(_mockGetBiometricTypeUseCase.execute())
          .thenAnswer((_) => Future.value(BiometricType.fingerprint));

      await _subject.checkType();

      verify(_mockGetBiometricTypeUseCase.execute()).called(1);

      await _blocTester.assertFullBlocOutputInOrder([
        BiometricTypeUninitializedState(),
        BiometricTypeLoadedState(
          assetName: SvgAssets.iconFingerPrint,
          label: LazyLocalizedStrings.useFingerprintButton,
        ),
      ]);
    });

    test('face', () async {
      when(_mockGetBiometricTypeUseCase.execute())
          .thenAnswer((_) => Future.value(BiometricType.face));

      await _subject.checkType();

      verify(_mockGetBiometricTypeUseCase.execute()).called(1);

      await _blocTester.assertFullBlocOutputInOrder([
        BiometricTypeUninitializedState(),
        BiometricTypeLoadedState(
          assetName: SvgAssets.iconFaceId,
          label: LazyLocalizedStrings.useFaceIDButton,
        ),
      ]);
    });

    test('not enabled', () async {
      when(_mockGetBiometricTypeUseCase.execute())
          .thenAnswer((_) => Future.value(null));

      await _subject.checkType();

      verify(_mockGetBiometricTypeUseCase.execute()).called(1);

      await _blocTester.assertFullBlocOutputInOrder([
        BiometricTypeUninitializedState(),
        BiometricTypeLoadedState(
          assetName: SvgAssets.iconBiometrics,
          label: LazyLocalizedStrings.useBiometricButton,
        ),
      ]);
    });
  });
}
