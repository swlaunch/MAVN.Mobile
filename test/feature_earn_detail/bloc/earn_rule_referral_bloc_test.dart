import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();

BlocTester<EarnRuleReferralsBloc> _blocTester =
    BlocTester(EarnRuleReferralsBloc(_mockReferralRepository));

EarnRuleReferralsBloc _subject;

void main() {
  group('EarnRuleReferralsBlocTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = EarnRuleReferralsBloc(_mockReferralRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(EarnRuleReferralsUninitializedState());
    });

    const _initialPage = 1;
    const _itemsPerPage = 100;

    test('get referrals success', () async {
      final referral = CustomerCommonReferralResponseModel();

      final _referralListResponseModel = ReferralsListResponseModel(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize,
          totalCount: TestConstants.stubTotalCount,
          referrals: [referral]);

      when(
        _mockReferralRepository.getReferralsForEarnRuleId(
          earnRuleId: TestConstants.stubEarnRuleId,
          currentPage: anyNamed('currentPage'),
          itemsCount: anyNamed('itemsCount'),
        ),
      ).thenAnswer((_) => Future.value(_referralListResponseModel));

      await _subject.getEarnRuleReferrals(TestConstants.stubEarnRuleId);

      verify(_mockReferralRepository.getReferralsForEarnRuleId(
        earnRuleId: TestConstants.stubEarnRuleId,
        currentPage: _initialPage,
        itemsCount: _itemsPerPage,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        EarnRuleReferralsUninitializedState(),
        EarnRuleReferralsLoadingState(),
        EarnRuleReferralsLoadedState(
          totalCount: TestConstants.stubTotalCount,
          referralList: [referral],
        )
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get referrals success, empty', () async {
      final _referralListResponseModel = ReferralsListResponseModel(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize,
          totalCount: TestConstants.stubTotalCount,
          referrals: []);

      when(
        _mockReferralRepository.getReferralsForEarnRuleId(
          earnRuleId: TestConstants.stubEarnRuleId,
          currentPage: anyNamed('currentPage'),
          itemsCount: anyNamed('itemsCount'),
        ),
      ).thenAnswer((_) => Future.value(_referralListResponseModel));

      await _subject.getEarnRuleReferrals(TestConstants.stubEarnRuleId);

      verify(_mockReferralRepository.getReferralsForEarnRuleId(
        earnRuleId: TestConstants.stubEarnRuleId,
        currentPage: _initialPage,
        itemsCount: _itemsPerPage,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        EarnRuleReferralsUninitializedState(),
        EarnRuleReferralsLoadingState(),
        EarnRuleReferralsEmptyState(),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get referrals generic error', () async {
      when(
        _mockReferralRepository.getReferralsForEarnRuleId(
          earnRuleId: TestConstants.stubEarnRuleId,
          currentPage: anyNamed('currentPage'),
          itemsCount: anyNamed('itemsCount'),
        ),
      ).thenThrow(Exception());

      await _subject.getEarnRuleReferrals(TestConstants.stubEarnRuleId);

      _expectedFullBlocOutput.addAll([
        EarnRuleReferralsUninitializedState(),
        EarnRuleReferralsLoadingState(),
        EarnRuleReferralsErrorState(
          errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
          errorSubtitle:
              LazyLocalizedStrings.referralListRequestGenericErrorSubtitle,
          iconAsset: SvgAssets.genericError,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get referrals network error', () async {
      when(_mockReferralRepository.getReferralsForEarnRuleId(
        earnRuleId: TestConstants.stubEarnRuleId,
        currentPage: anyNamed('currentPage'),
        itemsCount: anyNamed('itemsCount'),
      )).thenThrow(NetworkException());

      await _subject.getEarnRuleReferrals(TestConstants.stubEarnRuleId);

      _expectedFullBlocOutput.addAll([
        EarnRuleReferralsUninitializedState(),
        EarnRuleReferralsLoadingState(),
        EarnRuleReferralsNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
