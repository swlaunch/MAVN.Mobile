import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_sign_in_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../helpers/pin_helper.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

final _mockRepository = MockPinRepository();
PinSignInBloc _subject;
BlocTester<PinSignInBloc> _blocTester;
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();
final _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();

void main() {
  group('PinSignInBlocTests', () {
    setUp(() {
      reset(_mockRepository);

      final mobileSettings = MockMobileSettings();
      when(mobileSettings.pinCode).thenReturn(TestConstants.stubPinCode);
      when(_mockGetMobileSettingsUseCase.execute()).thenReturn(mobileSettings);

      _subject = PinSignInBloc(
        _mockRepository,
        _mockExceptionToMessageMapper,
        _mockGetMobileSettingsUseCase,
      );
      _blocTester = BlocTester(_subject);
    });

    test('PinEmptyState', () {
      _blocTester.assertCurrentState(PinEmptyState());
      expect(_subject.isSubmitVisible, true);
    });

    test('PinSignInState', () async {
      when(_mockRepository.checkPin([4, 4, 4, 4]))
          .thenAnswer((_) => Future.value(true));

      await addDigitsToPinBloc(_subject, 4, 4);

      await _blocTester.assertCurrentState(PinSignInState());
    });

    test('Warning state', () async {
      when(_mockRepository.checkPin([3, 3, 3, 3])).thenThrow(
          const ServiceException(ServiceExceptionType.pinCodeMismatch));

      await addDigitsToPinBloc(_subject, 3, 3 * 4);

      await _blocTester.assertCurrentState(
        PinErrorState(
          digits: [3, 3, 3, 3],
          isHidden: false,
          isSubmitVisible: false,
          error: LazyLocalizedStrings.pinErrorRemainingAttempts(2),
        ),
      );
    });

    test('PinReachedMaximumAttemptsState', () async {
      when(_mockRepository.checkPin([3, 3, 3, 3])).thenThrow(
          const ServiceException(ServiceExceptionType.pinCodeMismatch));

      await addDigitsToPinBloc(_subject, 3, 5 * 4);

      await _blocTester.assertCurrentState(
        PinReachedMaximumAttemptsState(),
      );
    });
  });
}
