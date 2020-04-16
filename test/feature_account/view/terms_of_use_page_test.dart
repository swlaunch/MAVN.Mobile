import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_terms_and_policies/view/terms_of_use_page.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

GetMobileSettingsUseCase _mockGetMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();
Widget _subjectWidget;
Router _mockRouter;

void main() {
  group('Terms of Use tests', () {
    setUp(() {
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
      _mockRouter = MockRouter();
    });

    testWidgets('MobileSettingsLoadedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester);
      expect(find.byType(WebView), findsOneWidget);
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
      mockRouter: _mockRouter,
      mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
      child: TermsOfUsePage(),
    );
