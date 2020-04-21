import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referal_bloc.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<LeadReferralBloc> _blocTester = BlocTester(
    LeadReferralBloc(_mockReferralRepository, _mockExceptionToMessageMapper));

LeadReferralBloc _subject;

void main() {
  group('LeadReferralBlockTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = LeadReferralBloc(
          _mockReferralRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(LeadReferralUninitializedState());
    });

    test('submitLeadReferral success', () async {
      await _subject.submitLeadReferral(
        firstName: ' ${TestConstants.stubFirstName} ',
        lastName: ' ${TestConstants.stubLastName} ',
        countryCode: TestConstants.stubCountryCode,
        phone: ' ${TestConstants.stubPhoneNumber} ',
        email: ' ${TestConstants.stubEmail} ',
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      verify(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('submitLeadReferral generic error', () async {
      when(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCode: TestConstants.stubCountryCode,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionErrorState(
            error: LazyLocalizedStrings.defaultGenericError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitLeadReferral network error', () async {
      when(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCode: TestConstants.stubCountryCode,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionErrorState(
            error: LazyLocalizedStrings.networkError, canRetry: true),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitLeadReferral referral lead already exists error', () async {
      when(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralLeadAlreadyExist,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.referralLeadAlreadyExistError);

      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCode: TestConstants.stubCountryCode,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionErrorState(
            error: LazyLocalizedStrings.referralLeadAlreadyExistError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitLeadReferral referral lead can not refer yourself error',
        () async {
      when(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.canNotReferYourself,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.canNotReferYourselfError);

      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCode: TestConstants.stubCountryCode,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionErrorState(
            error: LazyLocalizedStrings.canNotReferYourselfError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('submitLeadReferral referral lead already confirmed error', () async {
      when(_mockReferralRepository.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      )).thenThrow(const ServiceException(
        ServiceExceptionType.referralLeadAlreadyConfirmed,
      ));

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.referralLeadAlreadyConfirmedError);

      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCode: TestConstants.stubCountryCode,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      _expectedFullBlocOutput.addAll([
        LeadReferralUninitializedState(),
        LeadReferralSubmissionLoadingState(),
        LeadReferralSubmissionErrorState(
            error: LazyLocalizedStrings.referralLeadAlreadyConfirmedError,
            canRetry: false),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
