import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_create_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../helpers/pin_helper.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

PinCreateBloc _subject;
BlocTester<PinCreateBloc> _blocTester;
final _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();

void main() {
  group('PinCreateBlocTests', () {
    setUp(() {
      final mobileSettings = MockMobileSettings();
      when(mobileSettings.pinCode).thenReturn(TestConstants.stubPinCode);
      when(_mockGetMobileSettingsUseCase.execute()).thenReturn(mobileSettings);

      _subject = PinCreateBloc(_mockGetMobileSettingsUseCase);
      _blocTester = BlocTester(_subject);
    });

    test('PinEmptyState', () {
      _blocTester.assertCurrentState(PinEmptyState());
      expect(_subject.isSubmitVisible, false);
    });

    test('isSubmitVisible', () async {
      await addDigitsToPinBloc(_subject, 4, 4);
      expect(_subject.isSubmitVisible, true);
    });

    test('isSubmit Not Visible', () async {
      await addDigitsToPinBloc(_subject, 4, 3);
      expect(_subject.isSubmitVisible, false);
    });
  });
}
