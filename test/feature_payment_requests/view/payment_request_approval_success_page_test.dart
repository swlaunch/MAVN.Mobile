import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_approval_success_page.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

Router _mockRouter = MockRouter();

void main() {
  group('payment request approval success page', () {
    testWidgets('payment request approval success page close button',
        (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      await widgetTester.tap(find.byKey(const Key('backButton')));
      expect(verify(_mockRouter.maybePop()).callCount, 1);
    });

    testWidgets('Correct widget is shown', (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('paymentRequestApprovalSuccessWidget'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);
    });
    testWidgets('Go to Wallet redirects to Wallet tab', (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('formSuccessErrorButton'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);

      await widgetTester.tap(formSubmitButtonFinder);

      verify(_mockRouter.popToRoot()).called(1);
      verify(_mockRouter.switchToWalletTab()).called(1);
    });
  });
}

//////// HELPERS //////////

Widget _getSubjectWidget() => TestAppFrame(
    mockRouter: _mockRouter, child: PaymentRequestApprovalSuccessPage());
