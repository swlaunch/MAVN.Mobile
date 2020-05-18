import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('EarnRuleDetailBloc tests', () {
    final mockEarnRepository = MockEarnRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<EarnRuleDetailBloc> blocTester;
    EarnRuleDetailBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = EarnRuleDetailBloc(mockEarnRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(EarnRuleDetailUninitializedState());
    });

    test('loadEarnRule success', () async {
      final ExtendedEarnRule responseModel =
          TestConstants.stubExtendedEarnRuleWithStayHotelCondition;

      when(mockEarnRepository.getExtendedEarnRule(
              earnRuleId:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id))
          .thenAnswer((_) => Future.value(responseModel));

      await subject.loadEarnRule(
          TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id);

      expectedFullBlocOutput.addAll([
        EarnRuleDetailUninitializedState(),
        EarnRuleDetailLoadingState(),
        EarnRuleDetailLoadedState(
            earnRuleDetail:
                TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('loadEarnRule connectivity error', () async {
      when(mockEarnRepository.getExtendedEarnRule(
              earnRuleId:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id))
          .thenThrow(NetworkException());

      await subject.loadEarnRule(
          TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id);

      expectedFullBlocOutput.addAll([
        EarnRuleDetailUninitializedState(),
        EarnRuleDetailLoadingState(),
        EarnRuleDetailErrorState(
          errorTitle: LazyLocalizedStrings.networkErrorTitle,
          errorSubtitle: LazyLocalizedStrings.networkError,
          iconAsset: SvgAssets.networkError,
        ),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('loadEarnRule generic error', () async {
      when(mockEarnRepository.getExtendedEarnRule(
              earnRuleId:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id))
          .thenThrow(Exception());

      await subject.loadEarnRule(
          TestConstants.stubExtendedEarnRuleWithStayHotelCondition.id);

      expectedFullBlocOutput.addAll([
        EarnRuleDetailUninitializedState(),
        EarnRuleDetailLoadingState(),
        EarnRuleDetailErrorState(
          errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
          errorSubtitle:
              LazyLocalizedStrings.earnDetailPageGenericErrorSubTitle,
          iconAsset: SvgAssets.genericError,
        ),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
