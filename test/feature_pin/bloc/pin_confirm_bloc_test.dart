import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_confirm_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../helpers/pin_helper.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

PinConfirmBloc _subject;
BlocTester<PinConfirmBloc> _blocTester;
final _mockRepository = MockPinRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();
final _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();

void main() {
  group('PinConfirmBlocTests', () {
    setUp(() {
      reset(_mockRepository);

      final mobileSettings = MockMobileSettings();
      when(mobileSettings.pinCode).thenReturn(TestConstants.stubPinCode);
      when(_mockGetMobileSettingsUseCase.execute()).thenReturn(mobileSettings);

      _subject = PinConfirmBloc(
        _mockRepository,
        _mockExceptionToMessageMapper,
        _mockGetMobileSettingsUseCase,
      )..initialDigits = [1, 1, 1, 1];
      _blocTester = BlocTester(_subject);
    });

    test('PinEmptyState', () {
      _blocTester.assertCurrentState(PinEmptyState());
      expect(_subject.isSubmitVisible, false);
    });

    test('isSubmitVisible', () async {
      await addDigitsToPinBloc(_subject, 1, 4);
      expect(_subject.isSubmitVisible, true);
    });

    test('PinErrorState', () async {
      await addDigitsToPinBloc(_subject, 2, 4);

      await _blocTester.assertCurrentState(PinErrorState(
        error: LazyLocalizedStrings.pinErrorDoesNotMatch,
        isSubmitVisible: false,
        isHidden: true,
        digits: [2, 2, 2, 2],
      ));
    });

    test('storePin', () async {
      await addDigitsToPinBloc(_subject, 1, 4);

      await _subject.storePin();

      verify(_mockRepository.setPin([1, 1, 1, 1])).called(1);

      await _blocTester.assertFullBlocOutputInOrder([
        PinEmptyState(),
        PinFilledState(isSubmitVisible: false, isHidden: false, digits: [1]),
        PinFilledState(isSubmitVisible: false, isHidden: false, digits: [1, 1]),
        PinFilledState(
            isSubmitVisible: false, isHidden: false, digits: [1, 1, 1]),
        PinFilledState(
            isSubmitVisible: false, isHidden: false, digits: [1, 1, 1, 1]),
        PinLoadingEvent(),
        PinLoadingState(),
        PinLoadedEvent(),
        PinStoredState(),
        PinStoredEvent(),
      ]);
    });
  });
}
