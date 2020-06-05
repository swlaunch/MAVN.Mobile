import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/base_router.dart';
import 'package:pedantic/pedantic.dart';

import '../../helpers/widget_frames.dart';

WidgetTester _widgetTester;

GlobalKey<NavigatorState> _stubNavigatorKey;
GlobalKey _stubBottomNavBarKey;
BaseRouter _subject;

int currentBottomBarIndex;

void main() {
  group('BaseRouter tets', () {
    setUp(() {
      _stubNavigatorKey = GlobalKey<NavigatorState>();
      _stubBottomNavBarKey = GlobalKey();
      _subject = BaseRouter(_stubNavigatorKey, _stubBottomNavBarKey);
      currentBottomBarIndex = -1;
    });

    testWidgets('push', (widgetTester) async {
      await givenPage1IsInflated(widgetTester);

      await whenSubjectPushPage(Page2());

      thenPagesAreInTheWidgetTree(page1: false, page2: true, page3: false);

      await whenSubjectPushPage(Page3());

      thenPagesAreInTheWidgetTree(page1: false, page2: false, page3: true);

      thenThereIsMoreThanOneRouteInTheStack();
    });

    testWidgets('replace', (widgetTester) async {
      await givenPage1IsInflated(widgetTester);

      await whenSubjectReplacePage(Page2());

      thenPagesAreInTheWidgetTree(page1: false, page2: true, page3: false);

      await whenSubjectReplacePage(Page3());

      thenPagesAreInTheWidgetTree(page1: false, page2: false, page3: true);

      thenThereIsOnlyOneRouteInTheStack();
    });

    testWidgets('pop to root', (widgetTester) async {
      await givenPage1IsInflated(widgetTester);

      await whenSubjectPushPage(Page2());
      await whenSubjectShowDialog(Page3());

      await whenSubjectPopToRoot();

      thenPagesAreInTheWidgetTree(page1: true, page2: false, page3: false);
    });

    testWidgets('pop with value', (widgetTester) async {
      const stubPopValue = 'popValue';

      await givenPage1IsInflated(widgetTester);

      String resultValue;
      unawaited(_subject.pushPage<String>(Page2()).then((result) {
        resultValue = result;
      }));

      await widgetTester.pumpAndSettle();

      thenPagesAreInTheWidgetTree(page1: false, page2: true, page3: false);

      _subject.pop(stubPopValue);
      await widgetTester.pumpAndSettle();

      thenPagesAreInTheWidgetTree(page1: true, page2: false, page3: false);

      expect(resultValue, stubPopValue);
    });

    testWidgets('showDialog', (widgetTester) async {
      // Dialogs show on top of the current route, so the pages will be on top
      // of each other, so they are all in the widget tree by the end
      await givenPage1IsInflated(widgetTester);

      await whenSubjectShowDialog(Page2());

      thenPagesAreInTheWidgetTree(page1: true, page2: true, page3: false);

      await whenSubjectShowDialog(Page3());

      thenPagesAreInTheWidgetTree(page1: true, page2: true, page3: true);
    });

    testWidgets('popDialog with value', (widgetTester) async {
      const stubPopValue = 'popValue';

      await givenPage1IsInflated(widgetTester);

      String resultValue;
      unawaited(_subject.showDialog<String>(child: Page2()).then((result) {
        resultValue = result;
      }));

      await widgetTester.pumpAndSettle();

      expect(find.byType(Page1), findsOneWidget);
      expect(find.byType(Page2), findsOneWidget);

      _subject.popDialog(stubPopValue);
      await widgetTester.pumpAndSettle();

      expect(find.byType(Page1), findsOneWidget);
      expect(find.byType(Page2), findsNothing);

      expect(resultValue, stubPopValue);
    });

    testWidgets('popDialog with no dialogs open, stays on current page',
        (widgetTester) async {
      await givenPage1IsInflated(widgetTester);

      _subject.popDialog();
      await widgetTester.pumpAndSettle();

      thenPagesAreInTheWidgetTree(page1: true, page2: false, page3: false);
    });

    testWidgets('switch bottom bar navigation page', (widgetTester) async {
      await givenPage1IsInflated(widgetTester);

      await whenSubjectPushPage(PageWithBottomBar());

      await widgetTester.pumpAndSettle();

      expect(currentBottomBarIndex, -1);

      _subject.switchToTabAtIndex(1);

      expect(currentBottomBarIndex, 1);
    });
  });
}

Future givenPage1IsInflated(
  WidgetTester localWidgetTester,
) async {
  _widgetTester = localWidgetTester;

  await localWidgetTester.pumpWidget(TestAppFrame(
    child: Page1(),
    navigatorGlobalStateKey: _stubNavigatorKey,
  ));

  thenPagesAreInTheWidgetTree(page1: true, page2: false, page3: false);
}

Future<void> whenSubjectPushPage(Widget widget) async {
  unawaited(_subject.pushPage(widget));
  await _widgetTester.pumpAndSettle();
}

Future<void> whenSubjectReplacePage(Widget widget) async {
  unawaited(_subject.replacePage(widget));
  await _widgetTester.pumpAndSettle();
}

Future<void> whenSubjectShowDialog(Widget widget) async {
  unawaited(_subject.showDialog(child: widget));
  await _widgetTester.pumpAndSettle();
}

Future<void> whenSubjectPopToRoot() async {
  _subject.popToRoot();
  await _widgetTester.pumpAndSettle();
}

Future<void> whenSubjectPop() async {
  _subject.pop();
  await _widgetTester.pumpAndSettle();
}

void thenPagesAreInTheWidgetTree(
    {bool page1 = true, bool page2 = true, bool page3 = true}) {
  expect(find.byType(Page1), page1 ? findsOneWidget : findsNothing);
  expect(find.byType(Page2), page2 ? findsOneWidget : findsNothing);
  expect(find.byType(Page3), page3 ? findsOneWidget : findsNothing);
}

void thenThereIsOnlyOneRouteInTheStack() {
  expect(_stubNavigatorKey.currentState.canPop(), isFalse);
}

void thenThereIsMoreThanOneRouteInTheStack() {
  expect(_stubNavigatorKey.currentState.canPop(), isTrue);
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

class PageWithBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        key: _stubBottomNavBarKey,
        items: [
          BottomNavigationBarItem(icon: Container(), title: Container()),
          BottomNavigationBarItem(icon: Container(), title: Container()),
        ],
        onTap: (index) {
          currentBottomBarIndex = index;
        },
      );
}
