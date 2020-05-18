import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/feature_home/bloc/staking_referrals_bloc.dart';
import 'package:lykke_mobile_mavn/feature_home/bloc/staking_referrals_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();

BlocTester<StakingReferralsBloc> _blocTester =
    BlocTester(StakingReferralsBloc(_mockReferralRepository));

StakingReferralsBloc _subject;

void main() {
  group('StakingReferralsBlocTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = StakingReferralsBloc(_mockReferralRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(StakingReferralsUninitializedState());
    });

    const _initialPage = 1;
    const _itemsPerPage = 100;

    test('get referrals success, no staking referrals', () async {
      final _referralListResponseModel = ReferralsListResponseModel(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize,
          totalCount: TestConstants.stubTotalCount,
          referrals: [
            CustomerCommonReferralResponseModel(hasStaking: false),
          ]);

      when(
        _mockReferralRepository.getPendingReferrals(
          currentPage: anyNamed('currentPage'),
          itemsCount: anyNamed('itemsCount'),
        ),
      ).thenAnswer((_) => Future.value(_referralListResponseModel));

      await _subject.getStakingReferrals();

      verify(_mockReferralRepository.getPendingReferrals(
        currentPage: _initialPage,
        itemsCount: _itemsPerPage,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        StakingReferralsUninitializedState(),
        StakingReferralsLoadingState(),
        StakingReferralsEmptyState(),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get referrals generic error', () async {
      when(
        _mockReferralRepository.getPendingReferrals(
          currentPage: anyNamed('currentPage'),
          itemsCount: anyNamed('itemsCount'),
        ),
      ).thenThrow(Exception());

      await _subject.getStakingReferrals();

      _expectedFullBlocOutput.addAll([
        StakingReferralsUninitializedState(),
        StakingReferralsLoadingState(),
        StakingReferralsErrorState(
          errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
          errorSubtitle:
              LazyLocalizedStrings.referralListRequestGenericErrorSubtitle,
          iconAsset: SvgAssets.genericError,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get referrals network error', () async {
      when(_mockReferralRepository.getPendingReferrals(
        currentPage: anyNamed('currentPage'),
        itemsCount: anyNamed('itemsCount'),
      )).thenThrow(NetworkException());

      await _subject.getStakingReferrals();

      _expectedFullBlocOutput.addAll([
        StakingReferralsUninitializedState(),
        StakingReferralsLoadingState(),
        StakingReferralsNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
