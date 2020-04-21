import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc_output.dart';
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

BlocTester<AcceptLeadReferralBloc> _blocTester = BlocTester(
    AcceptLeadReferralBloc(_mockReferralRepository,
        _mockLocalSettingsRepository, _mockExceptionToMessageMapper));

AcceptLeadReferralBloc _subject;

void main() {
  group('AcceptLeadReferralBlocTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = AcceptLeadReferralBloc(_mockReferralRepository,
          _mockLocalSettingsRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(AcceptLeadReferralUninitializedState());
    });

    test('storeReferralCode', () async {
      await _subject.storeReferralCode(TestConstants.stubReferralCode);

      expect(
        verify(_mockLocalSettingsRepository
                .storeLeadReferralCode(TestConstants.stubReferralCode))
            .callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        AcceptLeadReferralUninitializedState(),
        LeadReferralSubmissionStoredKey()
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('hasPendingReferralConfirmation', () async {
      when(_mockLocalSettingsRepository.getLeadReferralCode())
          .thenReturn(TestConstants.stubReferralCode);

      expect(_subject.hasPendingReferralConfirmation(), isTrue);
    });

    test('hasPendingReferralConfirmation', () async {
      when(_mockLocalSettingsRepository.getLeadReferralCode()).thenReturn(null);

      expect(_subject.hasPendingReferralConfirmation(), isFalse);
    });

    test('acceptPendingReferral error', () async {
      when(_mockLocalSettingsRepository.getLeadReferralCode()).thenReturn(null);

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptLeadReferralUninitializedState(),
        AcceptLeadReferralLoadingState(),
        AcceptLeadReferralErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorTitle))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('acceptPendingReferral success path', () async {
      when(_mockLocalSettingsRepository.getLeadReferralCode())
          .thenReturn(SharedPreferencesKeys.leadReferralCode);

      when(_mockReferralRepository.leadReferralConfirm(
              code: SharedPreferencesKeys.leadReferralCode))
          .thenReturn(null);

      when(_mockLocalSettingsRepository.removeLeadReferralCode())
          .thenReturn(null);

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptLeadReferralUninitializedState(),
        AcceptLeadReferralLoadingState(),
        AcceptLeadReferralSuccessState()
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('acceptPendingReferral error', () async {
      when(_mockLocalSettingsRepository.getLeadReferralCode())
          .thenReturn(SharedPreferencesKeys.leadReferralCode);

      when(_mockReferralRepository.leadReferralConfirm(
              code: SharedPreferencesKeys.leadReferralCode))
          .thenReturn(null);

      when(_mockLocalSettingsRepository.removeLeadReferralCode()).thenThrow(
          const ServiceException(ServiceExceptionType.referralAlreadyConfirmed,
              message: TestConstants.stubErrorTitle));

      await _subject.acceptPendingReferral();

      _expectedFullBlocOutput.addAll([
        AcceptLeadReferralUninitializedState(),
        AcceptLeadReferralLoadingState(),
        AcceptLeadReferralErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorTitle))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
