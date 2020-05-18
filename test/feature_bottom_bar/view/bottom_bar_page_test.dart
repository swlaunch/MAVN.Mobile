import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/analytics/bottom_bar_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/bottom_bar_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc_output.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

BottomBarAnalyticsManager _mockBottomBarAnalyticsManager;
BottomBarPageBloc _mockBottomBarPageBloc;
WidgetTester _widgetTester;
Widget _subjectWidget;
final FirebaseMessagingBloc _mockFirebaseMessagingBloc =
    MockFirebaseMessagingBloc(FirebaseMessagingUninitializedState());

void main() {
  group('BottomBarPage tests', () {
    setUp(() {
      _mockBottomBarAnalyticsManager = MockBottomBarAnalyticsManager();
      _mockBottomBarPageBloc = MockBottomBarPageBloc(null);
    });

    testWidgets('navigated to Home tab', (widgetTester) async {
      await _givenSubjectWidgetPumped(widgetTester);

      await whenBottomBarItemWithNameTapped('Wallet');

      await whenBottomBarItemWithNameTapped('Explore');

      thenAssertPagesArePresent(isHomePagePresent: true);

      verify(_mockBottomBarAnalyticsManager.navigatedToHomeTab()).called(1);
      verify(_mockBottomBarPageBloc.init()).called(1);
    });

    testWidgets('navigated to Offers tab', (widgetTester) async {
      await _givenSubjectWidgetPumped(widgetTester);

      thenAssertPagesArePresent(isHomePagePresent: true);

      await whenBottomBarItemWithNameTapped('Offers');

      thenAssertPagesArePresent(isOffersPagePresent: true);

      verify(_mockBottomBarAnalyticsManager.navigatedToOffersTab()).called(1);
      verify(_mockBottomBarPageBloc.init()).called(1);
    });

    testWidgets('navigated to Wallet tab', (widgetTester) async {
      await _givenSubjectWidgetPumped(widgetTester);

      thenAssertPagesArePresent(isHomePagePresent: true);

      await whenBottomBarItemWithNameTapped('Wallet');

      thenAssertPagesArePresent(isWalletPagePresent: true);

      verify(_mockBottomBarAnalyticsManager.navigatedToWalletTab()).called(1);
      verify(_mockBottomBarPageBloc.init()).called(1);
    });

    testWidgets('navigated to Social tab', (widgetTester) async {
      await _givenSubjectWidgetPumped(widgetTester);

      thenAssertPagesArePresent(isHomePagePresent: true);

      await whenBottomBarItemWithNameTapped('Social');

      thenAssertPagesArePresent(isSocialPagePresent: true);

      verify(_mockBottomBarAnalyticsManager.navigatedToSocialTab()).called(1);
      verify(_mockBottomBarPageBloc.init()).called(1);
    });
  });
}

Future<void> whenBottomBarItemWithNameTapped(String name) async {
  await _widgetTester.tap(
    find.descendant(
        of: find.byType(BottomNavigationBar), matching: find.text(name)),
  );
  await _widgetTester.pumpAndSettle();
}

/// GIVEN

Future<void> _givenSubjectWidgetPumped(WidgetTester widgetTester) async {
  _widgetTester = widgetTester;
  _subjectWidget = _getSubjectWidget();
  await _widgetTester.pumpWidget(_subjectWidget);
}

// THEN

void thenAssertPagesArePresent({
  bool isHomePagePresent = false,
  bool isOffersPagePresent = false,
  bool isWalletPagePresent = false,
  bool isSocialPagePresent = false,
}) {
  expect(find.text('Home page'),
      isHomePagePresent ? findsOneWidget : findsNothing);
  expect(find.text('Offers page'),
      isOffersPagePresent ? findsOneWidget : findsNothing);
  expect(find.text('Wallet page'),
      isWalletPagePresent ? findsOneWidget : findsNothing);
  expect(find.text('Social page'),
      isSocialPagePresent ? findsOneWidget : findsNothing);
}

/// HELPERS

Widget _getSubjectWidget() {
  final mockBottomBarModule = MockBottomBarModule();
  when(mockBottomBarModule.bottomBarAnalyticsManager)
      .thenReturn(_mockBottomBarAnalyticsManager);

  when(mockBottomBarModule.homePage).thenReturn(const Text('Home page'));
  when(mockBottomBarModule.offersPage).thenReturn(const Text('Offers page'));
  when(mockBottomBarModule.voucherWalletPage)
      .thenReturn(const Text('Wallet page'));
  when(mockBottomBarModule.socialPage).thenReturn(const Text('Social page'));
  when(mockBottomBarModule.bottomBarPageBloc)
      .thenReturn(_mockBottomBarPageBloc);
  return TestAppFrame(
    mockFirebaseMessagingBloc: _mockFirebaseMessagingBloc,
    child: ModuleProvider<BottomBarModule>(
      module: mockBottomBarModule,
      child: BottomBarPage(),
    ),
  );
}
