import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/app.dart';
import 'package:lykke_mobile_mavn/app/bloc/app_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../helpers/widget_frames.dart';
import '../mock_classes.dart';

void main() {
  group('App tests', () {
    test('DEV is default environment', () {
      App();

      expect(App.environment, Environment.dev);
    });

    test('set non-default environment', () {
      App(environment: Environment.qa);

      expect(App.environment, Environment.qa);
    });

    testWidgets('AppStateInitialized', (tester) async {
      final mockAppStateInitialized = AppStateInitializedMock();

      final testAppModule = TestAppModule();
      when(mockAppStateInitialized.appModule).thenReturn(testAppModule);

      final mockAppBloc = MockAppBloc(mockAppStateInitialized);

      // We use runAsync because we have async stuff going on
      await tester.runAsync(() async {
        await tester.pumpWidget(getSubjectWidget(mockAppBloc));

        expect(find.byKey(const Key('app')), findsOneWidget);
      });
    });

    testWidgets('AppStateInitializing', (tester) async {
      final mockAppBloc = MockAppBloc(AppStateInitializing());
      await tester.pumpWidget(getSubjectWidget(mockAppBloc));

      expect(find.byKey(const Key('app')), findsNothing);
    });
  });
}

//////// HELPERS //////////
class AppStateInitializedMock extends Mock implements AppStateInitialized {}

Widget getSubjectWidget(AppBloc appBloc) => Provider.value(
      value: appBloc,
      child: App(),
    );
