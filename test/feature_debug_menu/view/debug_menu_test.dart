import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/app.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/debug_menu.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/debug_menu_banner.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/debug_menu_drawer.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

const stubProxyUrl = 'stubProxyUrl';

WidgetTester _widgetTester;

DebugMenuBloc _mockDebugMenuBloc;
Widget subjectWidget;

void main() {
  group('DebugMenu tests', () {
    setUp(() {
      _mockDebugMenuBloc =
          MockDebugMenuBloc(DebugMenuState(proxyUrl: stubProxyUrl));
      _widgetTester = null;
    });

    testWidgets('app flavor staging hides DebugMenuDrawer and DebugMenuBanner',
        (widgetTester) async {
      await _givenSubjectWidgetPumped(
          widgetTester: widgetTester, environment: Environment.staging);

      expect(find.byType(DebugMenuDrawer), findsNothing);

      await _whenDebugMenuDrawerIsOpened();

      expect(find.byType(DebugMenuDrawer), findsNothing);
      expect(find.text(stubProxyUrl), findsNothing);
    });

    testWidgets('app flavor prod hides DebugMenuDrawer and DebugMenuBanner',
        (widgetTester) async {
      await _givenSubjectWidgetPumped(
          widgetTester: widgetTester, environment: Environment.prod);

      expect(find.byType(DebugMenuDrawer), findsNothing);

      await _whenDebugMenuDrawerIsOpened();

      expect(find.byType(DebugMenuDrawer), findsNothing);
      expect(find.text(stubProxyUrl), findsNothing);
    });

    testWidgets('app flavor test shows DebugMenuDrawer and DebugMenuBanner',
        (widgetTester) async {
      await _givenSubjectWidgetPumped(
          widgetTester: widgetTester, environment: Environment.qa);

      expect(find.byType(DebugMenuBanner), findsOneWidget);

      await _whenDebugMenuDrawerIsOpened();

      expect(find.byType(DebugMenuDrawer), findsOneWidget);
      expect(find.text(stubProxyUrl), findsOneWidget);
    });

    testWidgets('proxySettingsInput calls DebugMenuBloc', (widgetTester) async {
      await _givenSubjectWidgetPumped(
        widgetTester: widgetTester,
      );

      await _whenDebugMenuDrawerIsOpened();

      await widgetTester.enterText(
          find.byKey(const Key('proxySettingsInput')), 'newProxyUrl');

      verify(_mockDebugMenuBloc.saveProxyUrl('newProxyUrl')).called(1);
    });

    testWidgets('proxySettingsInput clear', (widgetTester) async {
      await _givenSubjectWidgetPumped(
        widgetTester: widgetTester,
      );

      await _whenDebugMenuDrawerIsOpened();

      await widgetTester.tap(find.byKey(const Key('proxySettingsInputClear')));

      await widgetTester.pumpAndSettle();

      expect(find.text(stubProxyUrl), findsNothing);

      verify(_mockDebugMenuBloc.clearProxyUrl()).called(1);
    });

    testWidgets('expire session', (widgetTester) async {
      await _givenSubjectWidgetPumped(
        widgetTester: widgetTester,
      );

      await _whenDebugMenuDrawerIsOpened();

      await widgetTester
          .tap(find.byKey(const Key('debugMenuExpireSessionButton')));

      verify(_mockDebugMenuBloc.expireSession()).called(1);
    });
  });
}

////////// WHEN //////////

Future<void> _whenDebugMenuDrawerIsOpened() async {
  // Open the debug menu drawer by swiping right
  await _widgetTester.dragFrom(const Offset(0, 0), const Offset(1000, 0));
  await _widgetTester.pumpAndSettle();
}

//////// HELPERS //////////

Future<void> _givenSubjectWidgetPumped({
  WidgetTester widgetTester,
  Environment environment,
}) async {
  _widgetTester = widgetTester;

  subjectWidget = TestAppFrame(
    mockDebugMenuBloc: _mockDebugMenuBloc,
    child: DebugMenu(
      environment: environment,
    ),
  );

  await widgetTester.pumpWidget(subjectWidget);
}
