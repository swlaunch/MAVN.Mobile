import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_account/view/account_page.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/action_helper.dart';
import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

Router _mockRouter = MockRouter();
final LocalSettingsRepository _mockLocalSettingsRepository =
    MockLocalSettingsRepository();

final LogOutUseCase _mockLogOutUseCase = MockLogOutUseCase();
final _localizedStrings = LocalizedStrings();

void main() {
  setUpAll(() {
    initScreenshots();
  });

  setUp(() {
    reset(_mockLocalSettingsRepository);
    when(_mockLocalSettingsRepository.getCurrentAppVersion())
        .thenAnswer((_) => Future.value(TestConstants.stubLatestAppVersion));
  });

  group('Account Page tests', () {
    testWidgets('Account page displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(AccountPage), 'account_page');
    });

    testWidgets('Tapping referral option should navigate to the referral page',
        (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(
              Key(_localizedStrings.referralTrackingPersonalDetailsOption)),
          widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.pushReferralListPage);
    });

    testWidgets('Tapping contact us should navigate to the contact us page',
        (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(Key(_localizedStrings.contactUsButton)), widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.pushContactUsPage);
    });

    testWidgets(
        'Tapping terms of use should navigate to the '
        'terms of use page', (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(Key(_localizedStrings.termsOfUse)), widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.pushTermsOfUsePage);
    });

    testWidgets(
        'Tapping change password option should '
        'navigate to the change password page', (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(Key(_localizedStrings.accountPageChangePasswordOption)),
          widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.pushChangePasswordPage);
    });

    testWidgets(
        'Tapping personal details option should '
        'navigate to the personal details page', (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(Key(_localizedStrings.accountPagePersonalDetailsOption)),
          widgetTester);

      await thenTheFollowingRouteIsCalled(_mockRouter.pushPersonalDetailsPage);
    });

    testWidgets('Tapping logout option should navigate to the login page',
        (widgetTester) async {
      await _givenIAmOnTheAccountPage(widgetTester);

      await whenITapOn(
          find.byKey(Key(_localizedStrings.accountPageLogoutOption)),
          widgetTester);

      await thenTheFollowingRouteIsCalled(
          _mockRouter.showLogOutConfirmationDialog);
    });
  });
}

//////// HELPERS //////////
Future whenSettingsValueIsThenIExpect(WidgetTester widgetTester,
    {bool initialValue, bool expectedValue}) async {
  when(_mockLocalSettingsRepository.getUserHasAcceptedBiometricAuthentication())
      .thenReturn(initialValue);

  await _givenIAmOnTheAccountPage(widgetTester);

  await whenITapOn(
      find.byKey(
          Key(_localizedStrings.accountPageBiometricsSignInOptionAndroid)),
      widgetTester);

  final capturedArgs = verify(_mockLocalSettingsRepository
          .setUserHasAcceptedBiometricAuthentication(
              accepted: captureAnyNamed('accepted')))
      .captured;
  expect(capturedArgs[0], expectedValue);
}

Future<void> _givenIAmOnTheAccountPage(widgetTester) async =>
    await widgetTester.pumpWidget(_getSubjectWidget());

Widget _getSubjectWidget() => TestAppFrame(
    mockLogOutUseCase: _mockLogOutUseCase,
    mockRouter: _mockRouter,
    mockLocalSettingsRepository: _mockLocalSettingsRepository,
    child: AccountPage());
