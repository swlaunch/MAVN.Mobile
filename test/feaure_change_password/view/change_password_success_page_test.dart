import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_success_page.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

Router _mockRouter = MockRouter();

void main() {
  group('change password success page', () {
    testWidgets('change password success page close button',
        (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      await widgetTester.tap(find.byKey(const Key('backButton')));
      expect(verify(_mockRouter.maybePop()).callCount, 1);
    });

    testWidgets('Correct widget is shown', (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('changePasswordSuccessWidget'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);
    });
    testWidgets('Go to account redirects to Account tab', (widgetTester) async {
      await widgetTester.pumpWidget(_getSubjectWidget());

      final formSubmitButtonFinder = find.byKey(
        const Key('formSuccessErrorButton'),
      );

      expect(formSubmitButtonFinder, findsOneWidget);

      await widgetTester.tap(formSubmitButtonFinder);

      verify(_mockRouter.popToRoot()).called(1);
      verify(_mockRouter.pushAccountPage()).called(1);
    });
  });
}

//////// HELPERS //////////

Widget _getSubjectWidget() =>
    TestAppFrame(mockRouter: _mockRouter, child: ChangePasswordSuccessPage());
