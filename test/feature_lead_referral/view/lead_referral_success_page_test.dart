import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/view/lead_referral_success_page.dart';
import 'package:lykke_mobile_mavn/feature_partners/di/partner_name_di.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

Router _mockRouter = MockRouter();

void main() {
  group('lead referral success page', () {
    testWidgets('lead referral success page close button',
        (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      await widgetTester.tap(find.byKey(const Key('backButton')));
      expect(verify(_mockRouter.maybePop()).callCount, 1);
    });

    testWidgets('Correct widget is shown', (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('leadReferralSuccessWidget'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);
    });
    testWidgets('Go to Referrals redirects to Referral list',
        (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('formSuccessErrorButton'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);

      await widgetTester.tap(formSubmitButtonFinder);

      verify(_mockRouter.popToRoot()).called(1);
      verify(_mockRouter.pushReferralListPage()).called(1);
    });
  });
}

//////// HELPERS //////////

Widget _getSubjectWidget() => TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<PartnerNameModule>(
      module: PartnerNameModule(),
      child: LeadReferralSuccessPage(
        refereeFirstName: TestConstants.stubFirstName,
        refereeLastName: TestConstants.stubLastName,
        extendedEarnRule:
            TestConstants.stubExtendedEarnRuleWithStayHotelCondition,
      ),
    ));
