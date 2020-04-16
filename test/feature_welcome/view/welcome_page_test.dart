import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_welcome/di/welcome_module.dart';
import 'package:lykke_mobile_mavn/feature_welcome/view/welcome_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

WidgetTester _widgetTester;

Router _mockRouter;

Widget _subjectWidget;

void main() {
  group('WelcomePage tests', () {
    testWidgets('All widgets are present', (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      expect(find.byKey(const Key('welcomeSignInButton')), findsOneWidget);
      expect(
          find.byKey(const Key('welcomeCreateAccountButton')), findsOneWidget);
    });

    testWidgets('Clicking Sign in redirects to sign in', (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      expect(find.byKey(const Key('welcomeSignInButton')), findsOneWidget);
      await widgetTester.tap(find.byKey(const Key('welcomeSignInButton')));
      verify(_mockRouter.pushLoginPage()).called(1);
    });

    testWidgets('Clicking Create account redirects to registration',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester);

      expect(
          find.byKey(const Key('welcomeCreateAccountButton')), findsOneWidget);
      await widgetTester
          .tap(find.byKey(const Key('welcomeCreateAccountButton')));
      verify(_mockRouter.pushRegisterPage()).called(1);
    });
  });
}

Future<void> _getSubjectWidget(
  WidgetTester tester,
) async {
  _mockRouter = MockRouter();

  final mockWelcomeModule = MockWelcomeModule();
  when(mockWelcomeModule.welcomeAnalyticsManager)
      .thenReturn(MockWelcomeAnalyticsManager());

  _widgetTester = tester;

  _subjectWidget = TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<WelcomeModule>(
        module: mockWelcomeModule, child: WelcomePage()),
  );
  await _widgetTester.pumpWidget(_subjectWidget);
}
