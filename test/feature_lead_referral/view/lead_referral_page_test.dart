import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referal_bloc.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/di/lead_referral_di.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/view/lead_referral_page.dart';
import 'package:lykke_mobile_mavn/feature_partners/di/partner_name_di.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockLeadReferralBloc _mockBloc;
Router _mockRouter;
WidgetTester _widgetTester;

Widget _subjectWidget;
FormHelper _formHelper;

const Key _firstNameTextField = Key('firstNameTextField');
const Key _lastNameTextField = Key('lastNameTextField');
const Key _emailTextField = Key('emailTextField');
const Key _noteTextField = Key('noteTextField');
const Key _countryCodeField = Key('countryCodeField');
const Key _phoneNumberTextField = Key('phoneTextField');
const Key _submitButton = Key('submitButton');

void main() {
  group('LeadReferralPage tests', () {
    testWidgets('LeadReferralUnitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('LeadReferralSubmissionLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralSubmissionLoadingState(),
      );

      await _thenSubmitButtonIsDisabled();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('LeadReferralSubmissionErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralSubmissionErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
            canRetry: true),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
    });

    testWidgets('LeadReferralSubmissionErrorState retry button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralSubmissionErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
            canRetry: true),
      );
      await _whenIFillAllFieldsCorrectly();

      expect(find.byType(GenericErrorWidget), findsOneWidget);

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      _thenBlocLeadReferralCalled();
    });

    testWidgets('LeadReferralSubmissionSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: LeadReferralSubmissionSuccessEvent(),
        widgetTester: widgetTester,
      );

      expect(
          verify(_mockRouter.replaceWithLeadReferralSuccessPage(
                  refereeFirstName: '',
                  refereeLastName: '',
                  extendedEarnRule:
                      TestConstants.stubExtendedEarnRuleWithStayHotelCondition))
              .callCount,
          1);
    });

    // region first name

    testWidgets('first name invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubInvalidName,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenValidationErrorIsPresent('Invalid characters')
        ..thenTextFieldIsFocused(key: _firstNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('first name empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: '',
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenValidationErrorIsPresent('First name is required')
        ..thenTextFieldIsFocused(key: _firstNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('first name valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        'First name is required',
        'Invalid characters',
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('first name invalid - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubInvalidName,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Invalid characters')
        ..thenTextFieldIsFocused(key: _firstNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('first name empty - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: '',
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('First name is required')
        ..thenTextFieldIsFocused(key: _firstNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('first name valid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          'First name is required',
          'Invalid characters',
        ])
        ..thenTextFieldIsNotFocused(key: _firstNameTextField)
        ..thenTextFieldIsFocused(key: _lastNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets(
        'first name - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: '',
      );

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenTextFieldIsFocused(key: _firstNameTextField)
        ..thenTextFieldIsNotFocused(key: _lastNameTextField)
        ..thenSelectFieldIsNotFocused(key: _countryCodeField)
        ..thenTextFieldIsNotFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsNotFocused(key: _emailTextField)
        ..thenTextFieldIsNotFocused(key: _noteTextField);
    });

    // endregion first name

    // region last name

    testWidgets('last name invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubInvalidName,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Invalid characters');
      _thenBlocNotCalled();
    });

    testWidgets('last name empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: '',
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('First name is required');
      _thenBlocNotCalled();
    });

    testWidgets('last name valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubLastName,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        'Last name is required',
        'Invalid characters',
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('last name invalid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubInvalidName,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Invalid characters')
        ..thenTextFieldIsFocused(key: _lastNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('last name empty - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: '',
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Last name is required')
        ..thenTextFieldIsFocused(key: _lastNameTextField);
      _thenBlocNotCalled();
    });

    testWidgets('last name valid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubLastName,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          'Last name is required',
          'Invalid characters',
        ])
        ..thenSelectFieldIsFocused(key: _countryCodeField);
      _thenBlocNotCalled();
    });

    testWidgets(
        'last name - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: '',
      );

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenTextFieldIsNotFocused(key: _firstNameTextField)
        ..thenTextFieldIsFocused(key: _lastNameTextField)
        ..thenSelectFieldIsNotFocused(key: _countryCodeField)
        ..thenTextFieldIsNotFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsNotFocused(key: _emailTextField)
        ..thenTextFieldIsNotFocused(key: _noteTextField);
    });

    // endregion last name

    // region country code

    testWidgets(
        'country code does not show error if a code is selected'
        ' - validation after pressing submit', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );
      await _whenIFillAllFieldsCorrectly();

      await _formHelper.whenButtonTapped(_submitButton);
      expect(find.text('Country code is required'), findsNothing);
      _thenBlocLeadReferralCalled();
    });

    testWidgets('country code required - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenSelectedValue<CountryCode>(
        key: _countryCodeField,
        value: null,
      );

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Country code is required');
      _thenBlocNotCalled();
    });

    testWidgets(
        'country code - submit button validation focuses '
        'first invalid field', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubLastName,
      );
      await _formHelper.whenSelectedValue<CountryCode>(
        key: _countryCodeField,
        value: null,
      );

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenTextFieldIsNotFocused(key: _firstNameTextField)
        ..thenTextFieldIsNotFocused(key: _lastNameTextField)
        ..thenSelectFieldIsFocused(key: _countryCodeField)
        ..thenTextFieldIsNotFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsNotFocused(key: _emailTextField)
        ..thenTextFieldIsNotFocused(key: _noteTextField);
    });

    // endregion country code

    // region phone number

    testWidgets('phone number invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: TestConstants.stubInvalidPhoneNumber,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Invalid phone number');
      _thenBlocNotCalled();
    });

    testWidgets('phone number empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: '',
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Phone number is required');
      _thenBlocNotCalled();
    });

    testWidgets('phone number valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: TestConstants.stubValidPhoneNumber,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        'Phone number is required',
        'Invalid phone number',
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('phone number invalid - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: TestConstants.stubInvalidPhoneNumber,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Invalid phone number')
        ..thenTextFieldIsFocused(key: _phoneNumberTextField);
      _thenBlocNotCalled();
    });

    testWidgets('phone number empty - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(key: _phoneNumberTextField, value: '');
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Phone number is required')
        ..thenTextFieldIsFocused(key: _phoneNumberTextField);
      _thenBlocNotCalled();
    });

    testWidgets('phone number valid - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: TestConstants.stubValidPhoneNumber,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          'Phone number is required',
          'Invalid phone number',
        ])
        ..thenTextFieldIsNotFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsFocused(key: _emailTextField);
      _thenBlocNotCalled();
    });

    testWidgets('phone - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubLastName,
      );
      await _formHelper.whenSelectedValue<CountryCode>(
        key: _countryCodeField,
        value: TestConstants.stubCountryCode,
      );
      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: '',
      );

      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenTextFieldIsNotFocused(key: _firstNameTextField)
        ..thenTextFieldIsNotFocused(key: _lastNameTextField)
        ..thenSelectFieldIsNotFocused(key: _countryCodeField)
        ..thenTextFieldIsFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsNotFocused(key: _emailTextField)
        ..thenTextFieldIsNotFocused(key: _noteTextField);
    });

    // endregion phone number

    // region email

    testWidgets('email invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Please enter a valid email');
      _thenBlocNotCalled();
    });

    testWidgets('email empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(key: _emailTextField, value: '');
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent('Email is required');
      _thenBlocNotCalled();
    });

    testWidgets('email valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubValidEmail,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        'Email is required',
        'Please enter a valid email',
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('email invalid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Please enter a valid email')
        ..thenTextFieldIsFocused(key: _emailTextField);
      _thenBlocNotCalled();
    });

    testWidgets('email empty - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: '',
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent('Email is required')
        ..thenTextFieldIsFocused(key: _emailTextField);
      _thenBlocNotCalled();
    });

    testWidgets('email valid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: TestConstants.stubValidEmail,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          'Email is required',
          'Please enter a valid email',
        ])
        ..thenTextFieldIsNotFocused(key: _emailTextField)
        ..thenTextFieldIsFocused(key: _noteTextField);
      _thenBlocNotCalled();
    });

    testWidgets('email - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _firstNameTextField,
        value: TestConstants.stubFirstName,
      );
      await _formHelper.whenEnteredValue(
        key: _lastNameTextField,
        value: TestConstants.stubLastName,
      );
      await _formHelper.whenSelectedValue<CountryCode>(
        key: _countryCodeField,
        value: TestConstants.stubCountryCode,
      );
      await _formHelper.whenEnteredValue(
        key: _phoneNumberTextField,
        value: TestConstants.stubValidPhoneNumber,
      );
      await _formHelper.whenEnteredValue(
        key: _emailTextField,
        value: '',
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper
        ..thenTextFieldIsNotFocused(key: _firstNameTextField)
        ..thenTextFieldIsNotFocused(key: _lastNameTextField)
        ..thenSelectFieldIsNotFocused(key: _countryCodeField)
        ..thenTextFieldIsNotFocused(key: _phoneNumberTextField)
        ..thenTextFieldIsFocused(key: _emailTextField)
        ..thenTextFieldIsNotFocused(key: _noteTextField);
    });

    // endregion email

    // region note

    testWidgets('note exceeding character limit not possible',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _formHelper.whenTextFieldExceedsCharacterLimit(
          key: _noteTextField, limit: 1000);

      _formHelper.thenOnlyTheMaximumCharactersArePresent(
          key: _noteTextField, limit: 1000);
    });

    // endregion note

    testWidgets('LeadReferralPage submit button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();

      await widgetTester.ensureVisible(find.byKey(const Key('submitButton')));
      await widgetTester.tap(find.byKey(const Key('submitButton')));

      _thenBlocLeadReferralCalled();
    });

    testWidgets('Lead Referral page close button', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LeadReferralUninitializedState(),
      );

      await widgetTester.tap(find.byKey(const Key('backButton')));
      expect(verify(_mockRouter.maybePop()).callCount, 1);
    });
  });
}

// region given

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  LeadReferralState blocState,
) async {
  _mockRouter = MockRouter();
  _mockBloc = MockLeadReferralBloc(blocState);
  _subjectWidget = _getSubjectWidget(_mockBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(tester);

  await _widgetTester.pumpWidget(_subjectWidget);
}

// endregion given

// region when

Future<void> _whenIFillAllFieldsCorrectly() async {
  await _formHelper.whenEnteredValue(
    key: _firstNameTextField,
    value: TestConstants.stubFirstName,
  );
  await _formHelper.whenEnteredValue(
    key: _lastNameTextField,
    value: TestConstants.stubLastName,
  );
  await _formHelper.whenSelectedValue(
      key: _countryCodeField, value: TestConstants.stubCountryCode);
  await _formHelper.whenEnteredValue(
    key: _phoneNumberTextField,
    value: TestConstants.stubValidPhoneNumber,
  );
  await _formHelper.whenEnteredValue(
    key: _emailTextField,
    value: TestConstants.stubValidEmail,
  );
  await _formHelper.whenEnteredValue(
    key: _noteTextField,
    value: TestConstants.stubNote,
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
  verifyNever(_mockBloc.submitLeadReferral(
    firstName: captureAnyNamed('firstName'),
    lastName: captureAnyNamed('lastName'),
    countryCode: captureAnyNamed('countryCode'),
    email: captureAnyNamed('email'),
    phone: captureAnyNamed('phone'),
    note: captureAnyNamed('note'),
    earnRuleId: captureAnyNamed('earnRuleId'),
  ));
}

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.submitLeadReferral(
    firstName: captureAnyNamed('firstName'),
    lastName: captureAnyNamed('lastName'),
    countryCode: captureAnyNamed('countryCode'),
    phone: captureAnyNamed('phone'),
    email: captureAnyNamed('email'),
    note: captureAnyNamed('note'),
    earnRuleId: captureAnyNamed('earnRuleId'),
  ));
}

void _thenBlocLeadReferralCalled() {
  final capturedArgs = verify(_mockBloc.submitLeadReferral(
    firstName: captureAnyNamed('firstName'),
    lastName: captureAnyNamed('lastName'),
    countryCode: captureAnyNamed('countryCode'),
    phone: captureAnyNamed('phone'),
    email: captureAnyNamed('email'),
    note: captureAnyNamed('note'),
    earnRuleId: captureAnyNamed('earnRuleId'),
  )).captured;

  expect(capturedArgs[0], TestConstants.stubFirstName);
  expect(capturedArgs[1], TestConstants.stubLastName);
  expect(capturedArgs[2], TestConstants.stubCountryCode);
  expect(capturedArgs[3], TestConstants.stubValidPhoneNumber);
  expect(capturedArgs[4], TestConstants.stubValidEmail);
  expect(capturedArgs[5], TestConstants.stubNote);
}

//////// HELPERS //////////

Widget _getSubjectWidget(LeadReferralBloc leadReferralBloc) {
  final mockLeadReferralModule = MockLeadReferralModule();
  when(mockLeadReferralModule.leadReferralBloc).thenReturn(leadReferralBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<PartnerNameModule>(
      module: PartnerNameModule(),
      child: ModuleProvider<LeadReferralModule>(
        module: mockLeadReferralModule,
        child: LeadReferralPage(
            extendedEarnRule:
                TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
      ),
    ),
  );
}
