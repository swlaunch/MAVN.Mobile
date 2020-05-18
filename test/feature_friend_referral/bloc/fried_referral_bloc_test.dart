import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<FriendReferralBloc> _blocTester = BlocTester(FriendReferralBloc(
  _mockReferralRepository,
  _mockExceptionToMessageMapper,
));

FriendReferralBloc _subject;

void main() {
  group('FriendReferralBlockTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = FriendReferralBloc(
        _mockReferralRepository,
        _mockExceptionToMessageMapper,
      );
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(FriendReferralUninitializedState());
    });

    test('submitFriendReferral success', () async {
      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      expect(
        verify(_mockReferralRepository.submitFriendReferral(
          fullName: TestConstants.stubFullName,
          email: TestConstants.stubEmail,
          earnRuleId: TestConstants.stubEarnRuleId,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('submitFriendReferral generic error', () async {
      when(_mockReferralRepository.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionErrorState(
            error: LazyLocalizedStrings.defaultGenericError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitFriendReferral network error', () async {
      when(_mockReferralRepository.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionErrorState(
            error: LazyLocalizedStrings.networkError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitFriendReferral friend referral already confirmed', () async {
      when(_mockReferralRepository.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralAlreadyConfirmed,
      ));
      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.referralAlreadyConfirmedError);

      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionErrorState(
            error: LazyLocalizedStrings.referralAlreadyConfirmedError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitFriendReferral cannot refer yourself', () async {
      when(_mockReferralRepository.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.canNotReferYourself,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.canNotReferYourselfError);

      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionErrorState(
            error: LazyLocalizedStrings.canNotReferYourselfError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitFriendReferral referral already exists', () async {
      when(_mockReferralRepository.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralAlreadyExist,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.hotelReferralErrorLeadAlreadyExists);

      await _subject.submitFriendReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        FriendReferralUninitializedState(),
        FriendReferralSubmissionLoadingState(),
        FriendReferralSubmissionErrorState(
            error: LazyLocalizedStrings.hotelReferralErrorLeadAlreadyExists,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
