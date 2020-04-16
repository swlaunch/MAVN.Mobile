import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../helpers/bloc.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<PartnerNameBloc> _blocTester = BlocTester(PartnerNameBloc());

PartnerNameBloc _subject;

void main() {
  group('PartnerNameBlockTests', () {
    setUp(() {
      _expectedFullBlocOutput.clear();

      _subject = PartnerNameBloc();
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PartnerNameUninitializedState());
    });

    test('submitPartnerName with empty partners list', () async {
      await _subject.getPartnerName(
          extendedEarnRule:
              TestConstants.stubExtendedEarnRuleWithStayHotelCondition);

      _expectedFullBlocOutput.addAll([
        PartnerNameUninitializedState(),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('submitPartnerName success', () async {
      await _subject.getPartnerName(
          extendedEarnRule: TestConstants.stubExtendedEarnRuleWithPartners);

      _expectedFullBlocOutput.addAll([
        PartnerNameUninitializedState(),
        PartnerNameLoadedState(
            partnerName: TestConstants.stubExtendedEarnRuleWithPartners
                .conditions.first.partners.first.name)
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });
  });
}
