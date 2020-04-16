import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/view/set_phone_number_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

MockSetPhoneNumberBloc _mockBloc;
Router _mockRouter;
Widget _subjectWidget;

void main() {
  group('SetPhoneNumberPage tests', () {
    testWidgets('SetPhoneNumberUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        SetPhoneNumberUninitializedState(),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('SetPhoneNumberLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        SetPhoneNumberLoadingState(),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('SetPhoneNumberEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        SetPhoneNumberLoadingState(),
      );

      await _mockBloc.testNewEvent(
        event: SetPhoneNumberEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.pushPhoneCodeVerificationPage()).called(1);
    });

    testWidgets('SetPhoneNumberErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        SetPhoneNumberErrorState(errorMessage: TestConstants.stubErrorText),
      );

      await _whenIFillFormCorrectly();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
    });

    testWidgets('submit setPhoneNumber with valid fields',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        SetPhoneNumberUninitializedState(),
      );

      await _whenIFillFormCorrectly();
      await _whenSetPhoneNumberButtonTapped();

      _thenBlocSetPhoneNumberCalled();
    });
  });
}

//region GIVEN

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  SetPhoneNumberState blocState,
) async {
  _mockRouter = MockRouter();
  _mockBloc = MockSetPhoneNumberBloc(blocState);
  _subjectWidget = _getSubjectWidget(_mockBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}
//endregion
//region WHEN

Future<void> _whenSetPhoneNumberButtonTapped() async {
  await _widgetTester.tap(find.byKey(const Key('setPhoneNumberButton')));
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenSelectedCountryCode() async {
  await FormHelper(_widgetTester).whenSelectedValue<CountryCode>(
      key: const Key('countryCodeField'), value: TestConstants.stubCountryCode);
}

Future<void> _whenEnteredValidPhoneNumber() async {
  await _widgetTester.enterText(find.byKey(const Key('phoneNumberTextField')),
      TestConstants.stubValidPhoneNumber);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenIFillFormCorrectly() async {
  await _whenSelectedCountryCode();
  await _whenEnteredValidPhoneNumber();
  await _whenSetPhoneNumberButtonTapped();
}

//endregion
//region THEN

void _thenBlocSetPhoneNumberCalled() {
  final capturedArgs = verify(_mockBloc.setPhoneNumber(
          phoneNumber: captureAnyNamed('phoneNumber'),
          countryPhoneCodeId: captureAnyNamed('countryPhoneCodeId')))
      .captured;

  expect(capturedArgs[0], TestConstants.stubValidPhoneNumber);
  expect(capturedArgs[1], TestConstants.stubCountryCodeId);
}

//endregion
//region HELPERS
Widget _getSubjectWidget(SetPhoneNumberBloc setPhoneNumberBloc) {
  final mockSetPhoneNumberModule = MockPhoneNumberVerificationModule();
  when(mockSetPhoneNumberModule.setPhoneNumberBloc)
      .thenReturn(setPhoneNumberBloc);
  when(mockSetPhoneNumberModule.phoneNumberVerificationAnalyticsManager)
      .thenReturn(MockPhoneNumberVerificationAnalyticsManager());

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<PhoneNumberVerificationModule>(
      module: mockSetPhoneNumberModule,
      child: SetPhoneNumberPage(),
    ),
  );
}
//endregion
