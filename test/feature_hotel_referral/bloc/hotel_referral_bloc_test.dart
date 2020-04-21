import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<HotelReferralBloc> _blocTester = BlocTester(
    HotelReferralBloc(_mockReferralRepository, _mockExceptionToMessageMapper));

HotelReferralBloc _subject;

void main() {
  group('HotelReferralBlockTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = HotelReferralBloc(
          _mockReferralRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(HotelReferralUninitializedState());
    });

    test('submitHotelReferral success', () async {
      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      expect(
        verify(_mockReferralRepository.submitHotelReferral(
          fullName: TestConstants.stubFullName,
          email: TestConstants.stubEmail,
          countryCodeId: TestConstants.stubCountryCodeId,
          phoneNumber: TestConstants.stubPhoneNumber,
          earnRuleId: TestConstants.stubEarnRuleId,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral generic error', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.defaultGenericError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral network error', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.networkError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral hotel referral already confirmed', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralAlreadyConfirmed,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.referralAlreadyConfirmedError);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.referralAlreadyConfirmedError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral referral limit exceeded', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralsLimitExceeded,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.referralsLimitExceededError);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.referralsLimitExceededError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral cannot refer yourself', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.canNotReferYourself,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.canNotReferYourselfError);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.canNotReferYourselfError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitHotelReferral referral already exists', () async {
      when(_mockReferralRepository.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralAlreadyExist,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.hotelReferralErrorLeadAlreadyExists);

      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        HotelReferralUninitializedState(),
        HotelReferralSubmissionLoadingState(),
        HotelReferralSubmissionErrorState(
            error: LazyLocalizedStrings.hotelReferralErrorLeadAlreadyExists,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
