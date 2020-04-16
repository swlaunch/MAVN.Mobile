import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_partners/view/partner_list_page.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

Router _mockRouter = MockRouter();

void main() {
  setUpAll(() {
    initScreenshots();
  });

  group('PartnerListPage tests', () {
    testWidgets('Partner page displays the correct content',
        (widgetTester) async {
      await _givenIAmOnThePartnerPage(widgetTester);

      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(PartnerListPage), 'partner_list_page');
    });
  });
}

//////// HELPERS //////////

Future<void> _givenIAmOnThePartnerPage(widgetTester) async =>
    await widgetTester.pumpWidget(_getSubjectWidget());

Widget _getSubjectWidget() => TestAppFrame(
    mockRouter: _mockRouter,
    child: const PartnerListPage(partners: [
      TestConstants.stubPartner,
      TestConstants.stubPartner,
      TestConstants.stubPartner,
      TestConstants.stubPartner
    ]));
