import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_forgot_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_forgot_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

final PinForgotBloc _mockPinForgotBloc = MockPinForgotBloc();
Router _mockRouter;
Widget _subjectWidget;

void main() {
  setUpAll(() {
    initScreenshots();
  });

  setUp(() {
    reset(_mockPinForgotBloc);
  });

  group('PinForgotPage tests', () {
    testWidgets('proceed button tapped', (widgetTester) async {
      await _givenSubjectWidget(widgetTester);

      await widgetTester.tap(find.byKey(const Key('proceedButton')));
      verify(_mockPinForgotBloc.resetPinPassCode()).called(1);
      verify(_mockRouter.navigateToLoginPage()).called(1);
    });

    testWidgets('back button tapped', (widgetTester) async {
      await _givenSubjectWidget(widgetTester);

      await widgetTester.tap(find.byKey(const Key('backButton')));
      verify(_mockRouter.maybePop()).called(1);
    });

    testWidgets('screenshot', (widgetTester) async {
      await _givenSubjectWidget(widgetTester);

      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(PinForgotPage), 'pin_forgot_page');
    });
  });
}

Future<void> _givenSubjectWidget(WidgetTester tester) async {
  _mockRouter = MockRouter();
  _subjectWidget = _getSubjectWidget();

  await tester.pumpWidget(_subjectWidget);
}

Widget _getSubjectWidget() {
  final PinModule _mockPinModule = MockPinModule();
  when(_mockPinModule.pinForgotBloc).thenReturn(_mockPinForgotBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<PinModule>(
      module: _mockPinModule,
      child: PinForgotPage(),
    ),
  );
}
