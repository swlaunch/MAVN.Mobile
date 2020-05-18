import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/earn_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('EarnRuleListBloc tests', () {
    final mockEarnRepository = MockEarnRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<EarnRuleListBloc> blocTester;
    EarnRuleListBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(mockEarnRepository);
      subject = EarnRuleListBloc(mockEarnRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(GenericListUninitializedState());
    });

    test('loadEarnRules success', () async {
      final EarnRuleListResponseModel earnRuleListResponseModel =
          EarnRuleListResponseModel(
        earnRuleList: TestConstants.stubEarnRuleList,
        totalCount: TestConstants.stubEarnRuleList.length,
        currentPage: TestConstants.stubCurrentPage,
      );

      when(mockEarnRepository.getEarnRules())
          .thenAnswer((_) => Future.value(earnRuleListResponseModel));

      await subject.getList();

      expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState<EarnRule>(
            totalCount: TestConstants.stubEarnRuleList.length,
            currentPage: TestConstants.stubCurrentPage,
            list: TestConstants.stubEarnRuleList)
      ]);

      await blocTester.assertFullBlocOutputInAnyOrder(expectedFullBlocOutput);
    });

    test('get earn rules generic error', () async {
      when(mockEarnRepository.getEarnRules(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await subject.getList();

      expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<EarnRule>(
            error: LazyLocalizedStrings.cannotGetOffersError,
            currentPage: 1,
            list: []),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('get referrals network error', () async {
      when(mockEarnRepository.getEarnRules(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(NetworkException());

      await subject.getList();

      expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
