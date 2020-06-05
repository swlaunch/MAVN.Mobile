import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/di/onboarding_module.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/view/onboarding_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

WidgetTester _widgetTester;

Router _mockRouter;
SharedPreferencesManager _mockSharedPreferencesManager;
OnboardingAnalyticsManager _mockOnboardingAnalyticsManager;
Widget _subjectWidget;
const Key nextButtonKey = Key('onboardingPageNextButton');
const Key skipButtonKey = Key('onboardingPageSkipButton');
const Key getStartedButtonKey = Key('onboardingPageGetStartedButton');
const int pageCount = 3;

void main() {
  setUp(() {
    _mockOnboardingAnalyticsManager = MockOnboardingAnalyticsManager();
  });
  group('OnboardingPage tests', () {
    testWidgets('All widgets are present', (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      expect(find.byKey(skipButtonKey), findsOneWidget);
      expect(find.byKey(nextButtonKey), findsOneWidget);
    });

    testWidgets('Get started is present on the last page',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      await goToLastPage(widgetTester);
      expect(find.byKey(getStartedButtonKey), findsOneWidget);
    });

    testWidgets('Analytics manager called when pages change',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      await goToLastPage(widgetTester);
      verify(_mockOnboardingAnalyticsManager.onboardingPageChanged(
          previousPage: 1));
      verify(_mockOnboardingAnalyticsManager.onboardingPageChanged(
          previousPage: 2));
    });

    testWidgets('Clicking Skip redirects to Welcome Page',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      expect(find.byKey(skipButtonKey), findsOneWidget);
      await widgetTester.tap(find.byKey(skipButtonKey));

      verify(_mockOnboardingAnalyticsManager.onboardingSkipped(skippedPage: 1))
          .called(1);
      verify(_mockRouter.replaceWithWelcomePage()).called(1);
    });

    testWidgets('Clicking Get Started redirects to Welcome Page',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      await goToLastPage(widgetTester);

      expect(find.byKey(getStartedButtonKey), findsOneWidget);

      await widgetTester.tap(find.byKey(getStartedButtonKey));

      verify(_mockOnboardingAnalyticsManager.onboardingCompleted()).called(1);
      verify(_mockRouter.replaceWithWelcomePage()).called(1);
    });
  });
}

Future<void> goToLastPage(WidgetTester widgetTester) async {
  for (var i = 1; i < pageCount; i++) {
    await widgetTester.tap(find.byKey(nextButtonKey));
    await widgetTester.pumpAndSettle();
  }
}

Future<void> _getSubjectWidget(
  WidgetTester tester,
) async {
  final mockOnboardingModule = MockOnboardingModule();
  when(mockOnboardingModule.onboardingAnalyticsManager)
      .thenReturn(_mockOnboardingAnalyticsManager);

  _mockRouter = MockRouter();

  _mockSharedPreferencesManager = MockSharedPreferencesManager();

  when(_mockSharedPreferencesManager.readBool(key: anyNamed('key')))
      .thenReturn(true);
  _widgetTester = tester;

  _subjectWidget = TestAppFrame(
    mockRouter: _mockRouter,
    mockSharedPreferencesManager: _mockSharedPreferencesManager,
    child: ModuleProvider<OnboardingModule>(
      module: mockOnboardingModule,
      child: OnboardingPage(),
    ),
  );
  await _widgetTester.pumpWidget(_subjectWidget);
}
