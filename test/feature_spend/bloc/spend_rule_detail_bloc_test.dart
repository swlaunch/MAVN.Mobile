import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('SpendRuleDetailBloc tests', () {
    final _mockSpendRepository = MockSpendRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<SpendRuleDetailBloc> blocTester;
    SpendRuleDetailBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = SpendRuleDetailBloc(_mockSpendRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(SpendRuleDetailUninitializedState());
    });

    test('loadSpendRule success', () async {
      when(_mockSpendRepository.getSpendRuleDetail(
              spendRuleId: TestConstants.stubSpendRuleHospitality.id))
          .thenAnswer(
              (_) => Future.value(TestConstants.stubSpendRuleHospitality));

      await subject.loadSpendRule(TestConstants.stubSpendRuleHospitality.id);

      expectedFullBlocOutput.addAll([
        SpendRuleDetailUninitializedState(),
        SpendRuleDetailLoadingState(),
        SpendRuleDetailLoadedState(
            spendRule: TestConstants.stubSpendRuleHospitality),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getSpendRules connectivity error', () async {
      when(_mockSpendRepository.getSpendRuleDetail(
              spendRuleId: TestConstants.stubSpendRuleHospitality.id))
          .thenThrow(NetworkException());

      await subject.loadSpendRule(TestConstants.stubSpendRuleHospitality.id);

      expectedFullBlocOutput.addAll([
        SpendRuleDetailUninitializedState(),
        SpendRuleDetailLoadingState(),
        SpendRuleDetailNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getSpendRules generic error', () async {
      when(_mockSpendRepository.getSpendRuleDetail(
              spendRuleId: TestConstants.stubSpendRuleHospitality.id))
          .thenThrow(Exception());

      await subject.loadSpendRule(TestConstants.stubSpendRuleHospitality.id);

      expectedFullBlocOutput.addAll([
        SpendRuleDetailUninitializedState(),
        SpendRuleDetailLoadingState(),
        SpendRuleDetailGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
