import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/view/phone_number_verification_page.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_ticker/di/ticker_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

MockPhoneNumberVerificationBloc _mockBloc;
MockPhoneVerificationGenerationBloc _mockPhoneVerificationGenerationBlocBloc;
MockTickerBloc _mockTickerBloc;
Router _mockRouter;
Widget _subjectWidget;
//TODO
void main() {
  group('PhoneNumberVerificationPage tests', () {
    testWidgets('PhoneNumberVerificationUninitializedState',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PhoneNumberVerificationUninitializedState(),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('PhoneNumberVerificationLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PhoneNumberVerificationLoadingState(),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('PhoneNumberVerificationEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PhoneNumberVerificationLoadingState(),
      );

      await _mockBloc.testNewEvent(
        event: PhoneNumberVerifiedEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.pushRootBottomBarPage()).called(1);
    });

    //region network errors
    testWidgets('network error verification generation', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester, PhoneNumberVerificationUninitializedState(),
          phoneVerificationGenerationState:
              PhoneVerificationGenerationNetworkErrorState());

      expect(find.byType(NetworkErrorWidget), findsOneWidget);
    });

    testWidgets('network error verification ', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PhoneNumberVerificationNetworkErrorState(),
      );

      expect(find.byType(NetworkErrorWidget), findsOneWidget);
    });

    //endregion network errors
  });
}

//region GIVEN

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  PhoneNumberVerificationState blocState, {
  PhoneVerificationGenerationState phoneVerificationGenerationState,
  TickerState tickerState,
}) async {
  _mockRouter = MockRouter();
  _mockBloc = MockPhoneNumberVerificationBloc(blocState);
  _mockPhoneVerificationGenerationBlocBloc =
      MockPhoneVerificationGenerationBloc(phoneVerificationGenerationState ??
          PhoneVerificationGenerationUninitializedState());
  _mockTickerBloc = MockTickerBloc(tickerState ?? TickerUninitializedState());
  _subjectWidget = _getSubjectWidget(
      _mockBloc, _mockPhoneVerificationGenerationBlocBloc, _mockTickerBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}
//endregion

//region HELPERS
Widget _getSubjectWidget(
    PhoneNumberVerificationBloc phoneNumberVerificationBloc,
    PhoneVerificationGenerationBloc phoneVerificationGenerationBloc,
    TickerBloc tickerBloc) {
  final mockPhoneNumberVerificationModule = MockPhoneNumberVerificationModule();
  final mockTickerModule = MockTickerModule();
  when(mockPhoneNumberVerificationModule.phoneNumberVerificationBloc)
      .thenReturn(phoneNumberVerificationBloc);
  when(mockPhoneNumberVerificationModule.phoneVerificationGenerationBloc)
      .thenReturn(phoneVerificationGenerationBloc);
  when(mockPhoneNumberVerificationModule
          .phoneNumberVerificationAnalyticsManager)
      .thenReturn(MockPhoneNumberVerificationAnalyticsManager());
  when(mockTickerModule.tickerBloc).thenReturn(tickerBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<TickerModule>(
      module: mockTickerModule,
      child: ModuleProvider<PhoneNumberVerificationModule>(
        module: mockPhoneNumberVerificationModule,
        child: PhoneNumberVerificationPage(),
      ),
    ),
  );
}
//endregion
