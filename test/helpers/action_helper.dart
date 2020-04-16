import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

Future<void> whenITapOn(
  Finder finder,
  WidgetTester widgetTester,
) async {
  await widgetTester.tap(finder);
}

Future<void> thenTheFollowingRouteIsCalled(Function routingFunction) async {
  verify(routingFunction()).called(1);
}

Future<void> thenTheFollowingRoutesAreCalled(
    List<Function> routingFunctions) async {
  routingFunctions
      .forEach((routingFunction) => verify(routingFunction()).called(1));
}
