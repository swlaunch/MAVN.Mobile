import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_account/view/account_page.dart';
import 'package:lykke_mobile_mavn/feature_account/view/contact_us_page.dart';
import 'package:lykke_mobile_mavn/feature_account_deactivated/view/account_deactivated_page.dart';
import 'package:lykke_mobile_mavn/feature_country_code/view/country_code_list_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_success_page.dart';
import 'package:lykke_mobile_mavn/feature_login/di/login_module.dart';
import 'package:lykke_mobile_mavn/feature_login/view/login_page.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/di/onboarding_module.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/view/onboarding_page.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_success_page.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/di/partner_payments_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/payment_request_list_page.dart';
import 'package:lykke_mobile_mavn/feature_register/di/register_module.dart';
import 'package:lykke_mobile_mavn/feature_register/view/register_page.dart';
import 'package:lykke_mobile_mavn/feature_splash/view/mandatory_app_upgrade_page.dart';
import 'package:lykke_mobile_mavn/feature_terms_and_policies/view/terms_of_use_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/di/wallet_unlinking_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/view/unlink_wallet_in_progress/unlink_wallet_in_progress_page.dart';
import 'package:lykke_mobile_mavn/feature_welcome/view/welcome_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:pedantic/pedantic.dart';

import '../../helpers/widget_frames.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;
GlobalKey<NavigatorState> _stubNavigatorStateGlobalKey =
    GlobalKey<NavigatorState>();

GlobalKey _stubBottomNavBarGlobalKey = GlobalKey();

Router _subject;

void main() {
  group('Router integration tests', () {
    setUp(() {
      _subject = Router(
          globalNavigatorStateKey: _stubNavigatorStateGlobalKey,
          globalBottomNavBarStateKey: _stubBottomNavBarGlobalKey);
    });

    testWidgets('onboarding page', (widgetTester) async {
      await _testPageIsPresent<OnboardingPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushOnboardingPage,
          pageName: 'onboarding_page');

      _thenWidgetTypesInDescendingOrderInTheWidgetTree(
          [typeOf<ModuleProvider<OnboardingModule>>(), OnboardingPage]);
    });

    testWidgets('welcome page', (widgetTester) async {
      await _testPageIsPresent<WelcomePage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushWelcomePage,
          pageName: 'welcome_page');
    });

    testWidgets('login page', (widgetTester) async {
      await _testPageIsPresent<LoginPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.replaceWithLoginPage,
          pageName: 'login_page');

      _thenWidgetTypesInDescendingOrderInTheWidgetTree(
          [typeOf<ModuleProvider<LoginModule>>(), LoginPage]);
    });

    testWidgets('register page', (widgetTester) async {
      await _testPageIsPresent<RegisterPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushRegisterPage,
          pageName: 'register_page');

      _thenWidgetTypesInDescendingOrderInTheWidgetTree(
          [typeOf<ModuleProvider<RegisterModule>>(), RegisterPage]);
    });

    testWidgets('hotel referral page', (widgetTester) async {
      await _testPageIsPresent<HotelReferralPage>(
          widgetTester: widgetTester,
          navigationFn: () => _subject.pushHotelReferralPage(
              TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
          pageName: 'hotel_referral_page');

//      _thenWidgetTypesInDescendingOrderInTheWidgetTree(
//          [typeOf<ModuleProvider<HotelReferralModule>>(), HotelReferralPage]);
    });

    testWidgets('hotel referral success page', (widgetTester) async {
      await _testPageIsPresent<HotelReferralSuccessPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.replaceWithHotelReferralSuccessPage,
          pageName: 'hotel_referral_success_page');
    });

    testWidgets('country code list page', (widgetTester) async {
      await _testPageIsPresent<CountryCodeListPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushCountryCodePage,
          pageName: 'country_code_list_page');
    });

    testWidgets('p2p transaction success page', (widgetTester) async {
      await _testPageIsPresent<TransactionSuccessPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.replaceWithTransactionSuccessPage,
          pageName: 'p2p_transaction_success_page');
    });

    testWidgets('account deactivated page', (widgetTester) async {
      await _testPageIsPresent<AccountDeactivatedPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushAccountDeactivatedPage,
          pageName: 'account_deactivated_page');
    });

    // TODO fix this!!
//    testWidgets('earn rule detail page', (widgetTester) async {
//      await _testPageIsPresent<EarnRuleDetailPage>(
//          widgetTester: widgetTester,
//          navigationFn: () =>
//              _subject.pushEarnRuleDetailsPage(TestConstants.stubEarnRule),
//          pageName: 'earn_rule_detail_page');
//    });

    testWidgets('contact us page', (widgetTester) async {
      await _testPageIsPresent<ContactUsPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushContactUsPage,
          pageName: 'contact_us_page');
    });

    testWidgets('terms of use page', (widgetTester) async {
      await _testPageIsPresent<TermsOfUsePage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushTermsOfUsePage,
          pageName: 'terms_of_use_page');
    });

    testWidgets('payment request list page', (widgetTester) async {
      await _testPageIsPresent<PaymentRequestListPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushPaymentRequestListPage,
          pageName: 'payment_request_list_page');

      _thenWidgetTypesInDescendingOrderInTheWidgetTree([
        typeOf<ModuleProvider<PartnerPaymentsModule>>(),
        PaymentRequestListPage
      ]);
    });

    testWidgets('account page', (widgetTester) async {
      await _testPageIsPresent<AccountPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushAccountPage,
          pageName: 'account_page');
    });

    testWidgets('mandatory app upgrade page', (widgetTester) async {
      await _testPageIsPresent<MandatoryAppUpgradePage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushRootMandatoryAppUpgradePage,
          pageName: 'mandatory_app_upgrade_page');
    });

    testWidgets('wallet unlinking in progress page', (widgetTester) async {
      await _testPageIsPresent<UnlinkWalletInProgressPage>(
          widgetTester: widgetTester,
          navigationFn: _subject.pushUnlinkWalletInProgressPage,
          pageName: 'unlink_wallet_in_progress_page');

      _thenWidgetTypesInDescendingOrderInTheWidgetTree([
        typeOf<ModuleProvider<WalletUnlinkingModule>>(),
        UnlinkWalletInProgressPage
      ]);
    });
  });
}

Future<void> _testPageIsPresent<T>({
  WidgetTester widgetTester,
  Function navigationFn,
  String pageName,
}) async {
  await _givenRootPagePushed(widgetTester);

  expect(find.byType(T), findsNothing);

  unawaited(navigationFn());
  await _waitForRouteTransition();

  _thenPageOfTypeIsPresentWithPageName<T>(pageName: pageName);
}

/// GIVEN

Future _givenRootPagePushed(WidgetTester tester) async {
  _widgetTester = tester;

  await _widgetTester.pumpWidget(
    TestAppFrame(
      child: RootPage(),
      navigatorGlobalStateKey: _stubNavigatorStateGlobalKey,
      mockRouter: _subject,
    ),
  );

  expect(find.byType(RootPage), findsOneWidget);
}

/// THEN

void _thenPageOfTypeIsPresentWithPageName<T>({pageName}) {
  expect(find.byType(RootPage), findsNothing);
  expect(find.byType(T), findsOneWidget);

  expect(
    pageName,
    ModalRoute.of(_widgetTester.element(find.byType(T))).settings.name,
  );
}

void _thenWidgetTypesInDescendingOrderInTheWidgetTree(
    List<Type> widgetTypesInOrder) {
  for (var i = 0; i < widgetTypesInOrder.length - 1; i++) {
    expect(
        find.descendant(
            of: find.byType(widgetTypesInOrder[i]),
            matching: find.byType(widgetTypesInOrder[i + 1])),
        findsOneWidget);
  }
}

/// HELPERS

Type typeOf<T>() => T;

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

Future<void> _waitForRouteTransition() async {
  await _widgetTester.pump();
  await _widgetTester.pump(const Duration(milliseconds: 350));
}
