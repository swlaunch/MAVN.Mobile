import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/di/hotel_referral_module.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_page.dart';
import 'package:lykke_mobile_mavn/feature_partners/di/partner_name_di.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockHotelReferralBloc _mockBloc;
Router _mockRouter;
MockExceptionToMessageMapper _mockExceptionToMessage;
WidgetTester _widgetTester;

Widget _subjectWidget;
FormHelper _formHelper;

const Key _fullNameTextField = Key('fullNameTextField');
const Key _emailTextField = Key('emailTextField');
const Key _countryCodeTextField = Key('countryCodeField');
const Key _phoneNumberTextField = Key('phoneNumberTextField');
const Key _submitButton = Key('submitButton');
final _localizedStrings = LocalizedStrings();

void main() {
  group('HotelReferralPage tests', () {
    testWidgets('HotelReferralUnitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('HotelReferralSubmissionLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralSubmissionLoadingState(),
      );

      await _thenSubmitButtonIsDisabled();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('HotelReferralSubmissionErrorState without retry button',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralSubmissionErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
            canRetry: false),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
      expect(
          find.byKey(const Key('genericErrorWidgetRetryButton')), findsNothing);
    });

    testWidgets('HotelReferralSubmissionErrorState retry button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralSubmissionErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
            canRetry: true),
      );
      await _whenIFillAllFieldsCorrectly();

      expect(find.byType(GenericErrorWidget), findsOneWidget);

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      _thenHotelReferralBlocCalled();
    });

    testWidgets('HotelReferralSubmissionSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: HotelReferralSubmissionSuccessEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.replaceWithHotelReferralSuccessPage(
        refereeFullName: anyNamed('refereeFullName'),
        extendedEarnRule: anyNamed('extendedEarnRule'),
      )).called(1);
    });

    // region email

    testWidgets('email invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Please enter a valid email');
      _thenHotelReferralBlocNotCalled();
    });

    testWidgets('email empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(key: _emailTextField, value: '');
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Email is required');
      _thenHotelReferralBlocNotCalled();
    });

    testWidgets('form valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();
      await _formHelper.whenButtonTapped(_submitButton);

      _thenHotelReferralBlocCalled();
    });

    testWidgets('email invalid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Please enter a valid email')
        ..thenTextFieldIsFocused(key: _emailTextField);
      _thenHotelReferralBlocNotCalled();
    });

    testWidgets('first field empty - done button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _fullNameTextField,
        value: '',
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.emptyFullNameClientSideValidationError)
        ..thenTextFieldIsFocused(key: _fullNameTextField);

      _thenHotelReferralBlocNotCalled();
    });

    testWidgets('form valid - done button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _thenHotelReferralBlocCalled();
    });

    testWidgets(
        'full name - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _givenIFillIn(
          fullName: '', email: '', countryCode: null, phoneNumber: '');

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenTextFieldIsFocused(key: _fullNameTextField);
    });

    // endregion email

    testWidgets('HotelReferralPage submit button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();

      await widgetTester.ensureVisible(find.byKey(const Key('submitButton')));
      await widgetTester.tap(find.byKey(const Key('submitButton')));

      _thenHotelReferralBlocCalled();
    });

    testWidgets('Hotel Referral page close button', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        HotelReferralUninitializedState(),
      );

      await widgetTester.tap(find.byKey(const Key('backButton')));
      verify(_mockRouter.maybePop()).called(1);
    });
  });
}

// region given

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  HotelReferralState blocState,
) async {
  _mockRouter = MockRouter();
  _mockExceptionToMessage = MockExceptionToMessageMapper();
  _mockBloc = MockHotelReferralBloc(blocState);
  _subjectWidget = _getSubjectWidget(_mockBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(tester);

  await _widgetTester.pumpWidget(_subjectWidget);
}

// endregion given

// region when

Future<void> _whenIFillAllFieldsCorrectly() async {
  await _givenIFillIn(
    fullName: TestConstants.stubFullName,
    email: TestConstants.stubValidEmail,
    countryCode: TestConstants.stubCountryCode,
    phoneNumber: TestConstants.stubValidPhoneNumber,
  );
}

Future<void> _givenIFillIn({
  String fullName,
  String email,
  CountryCode countryCode,
  String phoneNumber,
}) async {
  await _formHelper.whenEnteredValue(
    key: _fullNameTextField,
    value: fullName,
  );

  await _formHelper.whenEnteredValue(
    key: _emailTextField,
    value: email,
  );

  await _formHelper.whenSelectedValue<CountryCode>(
    key: _countryCodeTextField,
    value: countryCode,
  );

  await _formHelper.whenEnteredValue(
    key: _phoneNumberTextField,
    value: phoneNumber,
  );
}

// endregion when

// region then

Future<void> _thenSubmitButtonIsDisabled() async {
  final registerSubmitFinder = find.byKey(const Key('submitButton'));
  expect(registerSubmitFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(registerSubmitFinder).onPressed,
    isNull,
  );

  await _widgetTester.tap(registerSubmitFinder);
  verifyNever(_mockBloc.submitHotelReferral(
    fullName: captureAnyNamed('fullName'),
    email: captureAnyNamed('email'),
    countryCodeId: captureAnyNamed('countryCodeId'),
    phoneNumber: captureAnyNamed('phoneNumber'),
    earnRuleId: TestConstants.stubEarnRuleId,
  ));
}

void _thenHotelReferralBlocNotCalled() {
  verifyNever(_mockBloc.submitHotelReferral(
    fullName: captureAnyNamed('fullName'),
    email: captureAnyNamed('email'),
    countryCodeId: captureAnyNamed('countryCodeId'),
    phoneNumber: captureAnyNamed('phoneNumber'),
    earnRuleId: captureAnyNamed('earnRuleId'),
  ));
}

void _thenHotelReferralBlocCalled() {
  final capturedArgs = verify(_mockBloc.submitHotelReferral(
    fullName: captureAnyNamed('fullName'),
    email: captureAnyNamed('email'),
    countryCodeId: captureAnyNamed('countryCodeId'),
    phoneNumber: captureAnyNamed('phoneNumber'),
    earnRuleId: captureAnyNamed('earnRuleId'),
  )).captured;

  expect(capturedArgs[1], TestConstants.stubValidEmail);
}

//////// HELPERS //////////

Widget _getSubjectWidget(HotelReferralBloc hotelReferralBloc) {
  final mockModule = MockHotelReferralModule();
  when(mockModule.hotelReferralBloc).thenReturn(hotelReferralBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    mockExceptionToMessageMapper: _mockExceptionToMessage,
    child: ModuleProvider<PartnerNameModule>(
      module: PartnerNameModule(),
      child: ModuleProvider<HotelReferralModule>(
          module: mockModule,
          child: HotelReferralPage(
            extendedEarnRule:
                TestConstants.stubExtendedEarnRuleWithStayHotelCondition,
          )),
    ),
  );
}
