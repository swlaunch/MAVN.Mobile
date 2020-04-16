import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_account_deactivated/view/account_deactivated_page.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/action_helper.dart';
import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

Router _mockRouter = MockRouter();
ExceptionToMessageMapper _mockExceptionToMessage =
    MockExceptionToMessageMapper();
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase;

void main() {
  setUpAll(() {
    _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();
    when(_mockGetMobileSettingsUseCase.execute())
        .thenReturn(TestConstants.stubMobileSettings);
    initScreenshots();
  });

  group('AccountDeactivatedPage tests', () {
    testWidgets('Account deactivated page displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheAccountDeactivatedPage(widgetTester);

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byType(AccountDeactivatedPage), 'account_deactivated_page');
    });

    testWidgets('Tapping the back button should navigate to the previous page',
        (widgetTester) async {
      await _givenIAmOnTheAccountDeactivatedPage(widgetTester);

      await whenITapOn(find.byKey(const Key('backButton')), widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.maybePop);
    });
  });
}

//////// HELPERS //////////

Future<void> _givenIAmOnTheAccountDeactivatedPage(
        WidgetTester widgetTester) async =>
    widgetTester.pumpWidget(_getSubjectWidget());

Widget _getSubjectWidget() => TestAppFrame(
    mockRouter: _mockRouter,
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    mockExceptionToMessageMapper: _mockExceptionToMessage,
    child: AccountDeactivatedPage());
