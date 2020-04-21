import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();
final _mockLocalSettingsRepository = MockLocalSettingsRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<AcceptHotelReferralBloc> _blocTester = BlocTester(
    AcceptHotelReferralBloc(_mockReferralRepository,
        _mockLocalSettingsRepository, _mockExceptionToMessageMapper));

AcceptHotelReferralBloc _subject;

void main() {
  group('AcceptHotelReferralBlocTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = AcceptHotelReferralBloc(_mockReferralRepository,
          _mockLocalSettingsRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(AcceptHotelReferralUninitializedState());
    });

    test('storeReferralCode', () async {
      await _subject.storeReferralCode(TestConstants.stubReferralCode);

      expect(
        verify(_mockLocalSettingsRepository
                .storeHotelReferralCode(TestConstants.stubReferralCode))
            .callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        AcceptHotelReferralUninitializedState(),
        HotelReferralSubmissionStoredKey()
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('hasPendingReferralConfirmation', () async {
      when(_mockLocalSettingsRepository.getHotelReferralCode())
          .thenReturn(TestConstants.stubReferralCode);

      expect(_subject.hasPendingReferralConfirmation(), isTrue);
    });

    test('hasPendingReferralConfirmation', () async {
      when(_mockLocalSettingsRepository.getHotelReferralCode())
          .thenReturn(null);

      expect(_subject.hasPendingReferralConfirmation(), isFalse);
    });

    test('acceptPendingReferral error', () async {
      when(_mockLocalSettingsRepository.getHotelReferralCode())
          .thenReturn(null);

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptHotelReferralUninitializedState(),
        AcceptHotelReferralLoadingState(),
        AcceptHotelReferralErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorTitle))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('acceptPendingReferral success path', () async {
      when(_mockLocalSettingsRepository.getHotelReferralCode())
          .thenReturn(SharedPreferencesKeys.hotelReferralCode);

      when(_mockReferralRepository.hotelReferralConfirm(
              code: SharedPreferencesKeys.hotelReferralCode))
          .thenReturn(null);

      when(_mockLocalSettingsRepository.removeHotelReferralCode())
          .thenReturn(null);

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptHotelReferralUninitializedState(),
        AcceptHotelReferralLoadingState(),
        AcceptHotelReferralSuccessState()
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('acceptPendingReferral error', () async {
      when(_mockLocalSettingsRepository.getHotelReferralCode())
          .thenReturn(SharedPreferencesKeys.hotelReferralCode);

      when(_mockReferralRepository.hotelReferralConfirm(
              code: SharedPreferencesKeys.hotelReferralCode))
          .thenReturn(null);

      when(_mockLocalSettingsRepository.removeHotelReferralCode()).thenThrow(
          const ServiceException(ServiceExceptionType.referralAlreadyConfirmed,
              message: TestConstants.stubErrorTitle));

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptHotelReferralUninitializedState(),
        AcceptHotelReferralLoadingState(),
        AcceptHotelReferralErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorTitle))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
