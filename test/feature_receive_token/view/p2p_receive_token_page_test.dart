import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/di/p2p_receive_token_module.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/view/p2p_receive_token_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

P2pReceiveTokenBloc _mockReceiveTokenBloc;
Router _mockRouter;

Widget _subjectWidget;

void main() {
  group('P2pReceiveTokenPage tests', () {
    setUp(() {
      _mockRouter = MockRouter();
      _mockReceiveTokenBloc = null;
    });

    testWidgets('ReceiveTokenPageUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          receiveTokenPageState: ReceiveTokenPageUninitializedState());

      verify(_mockReceiveTokenBloc.getCustomer()).called(1);
      expect(find.byKey(const Key('receiveTokenLoadingSpinner')), findsNothing);
      expect(find.byKey(const Key('receiveTokenQR')), findsNothing);
      expect(find.byKey(const Key('receiveTokenError')), findsNothing);
    });

    testWidgets('ReceiveTokenPageLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          receiveTokenPageState: ReceiveTokenPageLoadingState());

      verify(_mockReceiveTokenBloc.getCustomer()).called(1);
      expect(
          find.byKey(const Key('receiveTokenLoadingSpinner')), findsOneWidget);
      expect(find.byKey(const Key('receiveTokenQR')), findsNothing);
      expect(find.byKey(const Key('receiveTokenError')), findsNothing);
    });

    testWidgets('ReceiveTokenPageErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          receiveTokenPageState: ReceiveTokenPageErrorState(
              errorTitle:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorTitle),
              errorSubtitle: LocalizedStringBuilder.custom(
                  TestConstants.stubErrorSubtitle),
              iconAsset: TestConstants.stubErrorIconAsset));

      verify(_mockReceiveTokenBloc.getCustomer()).called(1);
      expect(find.byKey(const Key('receiveTokenLoadingSpinner')), findsNothing);
      expect(find.byKey(const Key('receiveTokenQR')), findsNothing);
      expect(find.byKey(const Key('receiveTokenError')), findsOneWidget);

      expect(find.text(TestConstants.stubErrorTitle), findsOneWidget);
      expect(find.text(TestConstants.stubErrorSubtitle), findsOneWidget);
    });

    testWidgets('ReceiveTokenPageSuccess', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          receiveTokenPageState:
              ReceiveTokenPageSuccess(TestConstants.stubEmail));

      verify(_mockReceiveTokenBloc.getCustomer()).called(1);
      expect(find.byKey(const Key('receiveTokenLoadingSpinner')), findsNothing);
      expect(find.byKey(const Key('receiveTokenQR')), findsOneWidget);
      expect(find.byKey(const Key('receiveTokenError')), findsNothing);
    });
  });
}

//////// GIVEN //////////
Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  @required ReceiveTokenPageState receiveTokenPageState,
}) async {
  _mockReceiveTokenBloc = MockP2PReceiveTokenBloc(receiveTokenPageState);
  _subjectWidget = _getSubjectWidget(_mockReceiveTokenBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// HELPERS //////////
Widget _getSubjectWidget(P2pReceiveTokenBloc receiveTokenBloc) {
  final mockReceiveTokenModule = MockP2PReceiveTokenModule();
  when(mockReceiveTokenModule.p2pReceiveTokenBloc).thenReturn(receiveTokenBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<P2PReceiveTokenModule>(
        module: mockReceiveTokenModule, child: P2pReceiveTokenPage()),
  );
}
