import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_account/view/contact_us_page.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

GetMobileSettingsUseCase _mockGetMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();

Widget _subjectWidget;

void main() {
  group('Contact Us tests', () {
    setUpAll(() {
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
      initScreenshots();
    });

    testWidgets('ContactUs test', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester);

      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(ContactUsPage), 'contact_us_page');
    });
  });
}

//////// GIVEN //////////
Future<void> _givenSubjectWidgetWithInitialBlocState(
    WidgetTester tester) async {
  _subjectWidget = _getSubjectWidget();

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// HELPERS //////////
Widget _getSubjectWidget() => TestAppFrame(
      mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
      child: ContactUsPage(),
    );
