import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/spend_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('SpendRuleListBloc tests', () {
    final mockSpendRepository = MockSpendRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<SpendRuleListBloc> blocTester;
    SpendRuleListBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(mockSpendRepository);
      subject = SpendRuleListBloc(mockSpendRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(GenericListUninitializedState());
    });

    test('loadSpendRules success', () async {
      final SpendRuleListResponseModel spendRuleListResponseModel =
          SpendRuleListResponseModel(
        spendRuleList: TestConstants.stubSpendRuleList,
        totalCount: TestConstants.stubSpendRuleList.length,
        currentPage: TestConstants.stubCurrentPage,
      );

      when(mockSpendRepository.getSpendRules())
          .thenAnswer((_) => Future.value(spendRuleListResponseModel));

      await subject.getList();

      expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState<SpendRule>(
            totalCount: TestConstants.stubSpendRuleList.length,
            currentPage: TestConstants.stubCurrentPage,
            list: TestConstants.stubSpendRuleList)
      ]);

      await blocTester.assertFullBlocOutputInAnyOrder(expectedFullBlocOutput);
    });

    test('get spend rules generic error', () async {
      when(mockSpendRepository.getSpendRules(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await subject.getList();

      expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<SpendRule>(
            error: LazyLocalizedStrings.cannotGetOffersError,
            currentPage: 1,
            list: []),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('get referrals network error', () async {
      when(mockSpendRepository.getSpendRules(
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
