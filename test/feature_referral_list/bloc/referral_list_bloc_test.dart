import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/pending_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockReferralRepository = MockReferralRepository();

BlocTester<ReferralListBloc> _blocTester =
    BlocTester(PendingReferralListBloc(_mockReferralRepository));

ReferralListBloc _subject;

void main() {
  group('ReferralListBlocTests', () {
    setUp(() {
      reset(_mockReferralRepository);
      _expectedFullBlocOutput.clear();

      _subject = PendingReferralListBloc(_mockReferralRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(GenericListUninitializedState());
    });
    const _initialPage = 1;
    final _referralListResponseModel = ReferralsListResponseModel(
        currentPage: TestConstants.stubCurrentPage,
        pageSize: TestConstants.stubPageSize,
        totalCount: TestConstants.stubTotalCount,
        referrals: [
          CustomerCommonReferralResponseModel(),
        ]);

    test('get referrals success', () async {
      when(
        _mockReferralRepository.getPendingReferrals(
          currentPage: anyNamed('currentPage'),
        ),
      ).thenAnswer((_) => Future.value(_referralListResponseModel));

      await _subject.getList();

      verify(_mockReferralRepository.getPendingReferrals(
              currentPage: _initialPage))
          .called(1);

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState(
            totalCount: TestConstants.stubTotalCount,
            currentPage: TestConstants.stubCurrentPage,
            list: [..._referralListResponseModel.referrals])
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get referrals generic error', () async {
      when(_mockReferralRepository.getPendingReferrals(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<CustomerCommonReferralResponseModel>(
            error: LazyLocalizedStrings.referralListRequestGenericErrorSubtitle,
            currentPage: 1,
            list: []),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get referrals network error', () async {
      when(_mockReferralRepository.getPendingReferrals(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(NetworkException());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
