import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/view/email_verification_page.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/di/password_validation_module.dart';
import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/feature_register/di/register_module.dart';
import 'package:lykke_mobile_mavn/feature_register/view/register_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;
FormHelper _formHelper;

MockRegisterBloc _mockBloc;
MockPasswordValidationBloc _mockPasswordValidationBloc;
Router _mockRouter;
RegisterAnalyticsManager _mockRegisterAnalyticsManager;

Widget _subjectWidget;
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();

final _localizedStrings = LocalizedStrings();

void main() {
  group('RegisterPage tests', () {
    setUpAll(() {
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
    });

    testWidgets('RegisterUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      _thenRegisterNextButtonIsEnabled();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    //TODO fix
//    testWidgets('RegisterLoadingState', (widgetTester) async {
//      await _givenSubjectWidgetWithInitialBlocState(
//        widgetTester,
//        RegisterLoadingState(),
//      );
//
//      await _thenRegisterSubmitButtonIsDisabled();
//
//      expect(find.byType(CircularProgressIndicator), findsOneWidget);
//      expect(find.text(TestConstants.stubErrorText), findsNothing);
//    });

    testWidgets('RegisterSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterLoadingState(),
      );

      await _mockBloc.testNewEvent(
        event: RegisterSuccessEvent(registrationEmail: TestConstants.stubEmail),
        widgetTester: widgetTester,
      );

      expect(
          verify(_mockRouter.pushRootEmailVerificationPage(
                  email: TestConstants.stubEmail,
                  status: VerificationStatus.notVerified))
              .callCount,
          1);
    });

    testWidgets('RegisterErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      // Submission error shows only on the second form
      await _whenFirstPageFilledCorrectly();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
    });

    testWidgets('submit register with valid fields', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredValidPassword();
      await _whenTappedOnTermsOfUseCheckbox();
      await _whenRegisterSubmitButtonTapped();

      _thenBlocRegisterCalled();
    });

    testWidgets('validate email - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredInvalidEmail();
      await _whenRegisterNextButtonTapped();

      _thenEmailIsInvalidValidationErrorIsPresent();
      _thenEmailFieldIsFocused(true);
      _thenBlocNotCalled();
    });

    testWidgets(
        'validate email - if all fields are valid, after I press '
        'submit, auto validation is not turned on', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredValidPassword();
      await _whenRegisterSubmitButtonTapped();

      await _whenEnteredInvalidPassword();

      _thenNoEmailValidationError();
      _thenNoPasswordValidationError();
    });

    testWidgets(
        'validate email - if not all fields are valid, after I press submit '
        'auto validation is turned on', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );
      await _whenEnteredInvalidEmail();
      await _whenRegisterNextButtonTapped();

      _thenEmailIsInvalidValidationErrorIsPresent();

      await _whenEnteredValidEmail();

      _thenNoEmailValidationError();
      _thenBlocNotCalled();
    });

    testWidgets('validate email - empty email - tap Next button',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredEmptyEmail();
      await _whenRegisterNextButtonTapped();

      _thenEmailIsEmptyValidationErrorIsPresent();
      _thenBlocNotCalled();
    });

    testWidgets('validate email - invalid email - tap Next button',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredInvalidEmail();
      await _whenRegisterNextButtonTapped();

      _thenEmailIsInvalidValidationErrorIsPresent();
      _thenBlocNotCalled();
    });

    testWidgets(
        'validate password - validation after pressing submit with '
        'invalid pasword', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );
      await _whenFirstPageFilledCorrectly();
      await _whenEnteredInvalidPassword();
      await _whenRegisterSubmitButtonTapped();

      _thenPasswordIsInvalidValidationErrorIsPresent();
      _thenPasswordFieldIsFocused(true);
      _thenBlocNotCalled();
    });

    testWidgets('valid email, next button focuses the first name field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredValidEmail();
      await _whenKeyboardTextInputActionTapped(TextInputAction.next);

      _thenEmailFieldIsFocused(false);
      _thenFirstNameFieldIsFocused(true);
      _thenBlocNotCalled();
    });

    testWidgets(
        'invalid email, next button doesn\'t focus the first name '
        'field, shows only email validation error', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredInvalidEmail();
      await _whenKeyboardTextInputActionTapped(TextInputAction.next);

      _thenEmailFieldIsFocused(true);
      _thenFirstNameFieldIsFocused(false);
      _thenLastNameFieldIsFocused(false);
      _thenBlocNotCalled();
    });

    testWidgets('invalid email, next button pressed, auto validation enabled',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredInvalidEmail();
      _thenNoEmailValidationError();

      await _whenKeyboardTextInputActionTapped(TextInputAction.next);
      _thenEmailIsInvalidValidationErrorIsPresent();
      await _whenEnteredValidEmail();
      _thenNoEmailValidationError();
    });

    testWidgets(
        'valid email, valid first name, invalid last name, '
        'done button pressed, focus '
        'stays on last name field, auto validation enabled',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredValidEmail();
      await _whenEnteredValidFirstName();
      await _whenEnteredInvalidLastName();
      await _whenKeyboardTextInputActionTapped(TextInputAction.done);
      _thenNoEmailValidationError();
      _thenNoFirstNameValidationError();
      _thenLastNameIsInvalidValidationErrorIsPresent();
      _thenLastNameFieldIsFocused(true);

      await _whenEnteredValidLastName();
      _thenNoLastNameValidationError();
    });

    testWidgets(
        'invalid email, tapping submit button sends '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenRegisterNextButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager.nextButtonTapped()).callCount,
        1,
      );
    });

    testWidgets(
        'invalid passwords tapping submit button sends '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );
      await _whenFirstPageFilledCorrectly();
      await _whenEnteredInvalidPassword();
      await _whenRegisterSubmitButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager.nextButtonTapped()).callCount,
        1,
      );
    });

    testWidgets(
        'valid passwords tapping submit button sends '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenSecondPageFilledCorrectly();
      await _whenRegisterSubmitButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager.submitButtonTapped()).callCount,
        1,
      );
    });

    testWidgets(
        'invalid password, tapping password keyboard next button sends '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredInvalidPassword();
      await _whenKeyboardTextInputActionTapped(TextInputAction.next);

      expect(
        verify(_mockRegisterAnalyticsManager.passwordKeyboardNextButtonTapped())
            .callCount,
        1,
      );
    });

    testWidgets(
        'unchecked terms of use should result in an error message'
        ' only after submit', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredValidPassword();
      await _whenRegisterSubmitButtonTapped();

      _thenTermsOfUseErrorIsPresent();
      _thenBlocNotCalled();

      await _whenTappedOnTermsOfUseCheckbox();
      _thenNoTermsOfUseError();
    });

/////////////////////////////////////////////////////////////////////////////////////////////

    testWidgets(
        'valid email, tapping email keyboard next button sends '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredValidEmail();
      await _whenKeyboardTextInputActionTapped(TextInputAction.next);

      expect(
        verify(_mockRegisterAnalyticsManager.emailKeyboardNextButtonTapped())
            .callCount,
        1,
      );
    });

    testWidgets(
        'valid email, invalid password, tapping password keyboard '
        'done button sends analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredInvalidPassword();
      await _whenKeyboardTextInputActionTapped(TextInputAction.done);

      expect(
        verify(_mockRegisterAnalyticsManager.passwordKeyboardNextButtonTapped())
            .callCount,
        1,
      );
    });

    testWidgets(
        'valid email, valid password, tapping password keyboard done '
        'button sends analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredValidPassword();
      await _whenKeyboardTextInputActionTapped(TextInputAction.done);

      expect(
        verify(_mockRegisterAnalyticsManager.passwordKeyboardNextButtonTapped())
            .callCount,
        1,
      );
    });

    testWidgets(
        'invalid email, sends email invalid client validation error '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredInvalidEmail();
      await _whenRegisterNextButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager
                .emailInvalidClientValidationError())
            .callCount,
        1,
      );
    });

    testWidgets(
        'empty email, sends email empty client validation error '
        'analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenEnteredEmptyEmail();
      await _whenRegisterNextButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager.emailEmptyClientValidationError())
            .callCount,
        1,
      );
    });

    testWidgets(
        'valid email, invalid password, sends invalid password client '
        'validation error analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredInvalidPassword();
      await _whenRegisterSubmitButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager
                .passwordInvalidClientValidationError())
            .callCount,
        5,
      );
    });

    testWidgets(
        'valid email, empty password, sends empty password client '
        'validation error analytics event', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        RegisterUninitializedState(),
      );

      await _whenFirstPageFilledCorrectly();
      await _whenEnteredEmptyPassword();
      await _whenRegisterSubmitButtonTapped();

      expect(
        verify(_mockRegisterAnalyticsManager
                .passwordEmptyClientValidationError())
            .callCount,
        1,
      );
    });
  });
}

//region GIVEN

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  RegisterState blocState,
) async {
  _mockRouter = MockRouter();
  _mockBloc = MockRegisterBloc(blocState);
  _mockPasswordValidationBloc =
      MockPasswordValidationBloc(PasswordValidationUninitializedState());
  _mockRegisterAnalyticsManager = MockRegisterAnalyticsManager();
  _subjectWidget = _getSubjectWidget(_mockBloc, _mockPasswordValidationBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(_widgetTester);

  await _widgetTester.pumpWidget(_subjectWidget);
}
//endregion
//region WHEN

Future<void> _whenKeyboardTextInputActionTapped(
    TextInputAction inputAction) async {
  await _widgetTester.testTextInput.receiveAction(inputAction);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenRegisterNextButtonTapped() async {
  await _widgetTester.tap(find.byKey(const Key('registerNextButton')));
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenRegisterSubmitButtonTapped() async {
  await _widgetTester.tap(find.byKey(const Key('registerSubmitButton')));
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredValidEmail() async {
  await _widgetTester.enterText(
      find.byKey(const Key('emailTextField')), TestConstants.stubValidEmail);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredInvalidEmail() async {
  await _widgetTester.enterText(
      find.byKey(const Key('emailTextField')), TestConstants.stubInvalidEmail);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredEmptyEmail() async {
  await _widgetTester.enterText(
      find.byKey(const Key('emailTextField')), TestConstants.stubEmpty);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredValidFirstName() async {
  await _widgetTester.enterText(
      find.byKey(const Key('firstNameTextField')), TestConstants.stubFirstName);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredValidLastName() async {
  await _widgetTester.enterText(
      find.byKey(const Key('lastNameTextField')), TestConstants.stubLastName);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredInvalidLastName() async {
  await _widgetTester.enterText(find.byKey(const Key('lastNameTextField')),
      TestConstants.stubInvalidName);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredValidPassword() async {
  await _widgetTester.enterText(find.byKey(const Key('passwordTextField')),
      TestConstants.stubValidPassword);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredInvalidPassword() async {
  await _widgetTester.enterText(find.byKey(const Key('passwordTextField')),
      TestConstants.stubInvalidPassword);
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredEmptyPassword() async {
  await _widgetTester.enterText(find.byKey(const Key('passwordTextField')), '');
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenTappedOnTermsOfUseCheckbox() async {
  await _widgetTester.tap(find.byKey(const Key('termsOfUseCheckbox')));
  await _widgetTester.pumpAndSettle();
}

Future<void> _whenEnteredValidCountryOfNationality() async {
  await _formHelper.whenSelectedValue<Country>(
      key: const Key('nationalityField'), value: TestConstants.stubCountry);

  await _widgetTester.pumpAndSettle();
}

Future<void> _whenFirstPageFilledCorrectly() async {
  await _whenEnteredValidEmail();
  await _whenEnteredValidFirstName();
  await _whenEnteredValidLastName();
  await _whenEnteredValidCountryOfNationality();
  await _whenRegisterNextButtonTapped();
}

Future<void> _whenSecondPageFilledCorrectly() async {
  await _whenEnteredValidPassword();
}
//endregion
//region THEN

void _thenBlocRegisterCalled() {
  final capturedArgs = verify(_mockBloc.register(
    email: captureAnyNamed('email'),
    password: captureAnyNamed('password'),
    firstName: captureAnyNamed('firstName'),
    lastName: captureAnyNamed('lastName'),
    countryOfNationalityId: captureAnyNamed('countryOfNationalityId'),
  )).captured;

  expect(capturedArgs[0], TestConstants.stubValidEmail);
  expect(capturedArgs[1], TestConstants.stubValidPassword);
  expect(capturedArgs[2], TestConstants.stubFirstName);
  expect(capturedArgs[3], TestConstants.stubLastName);
  expect(capturedArgs[4], TestConstants.stubCountryId);
}

void _thenRegisterNextButtonIsEnabled() {
  final registerNextFinder = find.byKey(const Key('registerNextButton'));
  expect(registerNextFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(registerNextFinder).onPressed,
    isNotNull,
  );
}

void _thenPasswordFieldIsFocused(isFocused) {
  final passwordTextFieldFinder = find.descendant(
      of: find.byKey(const Key('passwordTextField')),
      matching: find.byType(TextField),
      matchRoot: true);

  expect(
      _widgetTester
          .widget<TextField>(passwordTextFieldFinder)
          .focusNode
          .hasFocus,
      isFocused);
}

//void _thenPasswordFieldIsObscured(isObscured) {
//  final passwordTextFieldFinder = find.descendant(
//      of: find.byKey(const Key('passwordTextField')),
//      matching: find.byType(TextField),
//      matchRoot: true);
//
//  expect(_widgetTester.widget<TextField>(passwordTextFieldFinder).obscureText,
//      isObscured);
//}

void _thenEmailFieldIsFocused(isFocused) {
  final emailTextFieldFinder = find.descendant(
    of: find.byKey(const Key('emailTextField')),
    matching: find.byType(TextField),
    matchRoot: true,
  );

  expect(
      _widgetTester.widget<TextField>(emailTextFieldFinder).focusNode.hasFocus,
      isFocused);
}

void _thenFirstNameFieldIsFocused(isFocused) {
  final firstNameTextFieldFinder = find.descendant(
    of: find.byKey(const Key('firstNameTextField')),
    matching: find.byType(TextField),
    matchRoot: true,
  );

  expect(
      _widgetTester
          .widget<TextField>(firstNameTextFieldFinder)
          .focusNode
          .hasFocus,
      isFocused);
}

void _thenLastNameFieldIsFocused(isFocused) {
  final lastNameTextFieldFinder = find.descendant(
    of: find.byKey(const Key('lastNameTextField')),
    matching: find.byType(TextField),
    matchRoot: true,
  );

  expect(
      _widgetTester
          .widget<TextField>(lastNameTextFieldFinder)
          .focusNode
          .hasFocus,
      isFocused);
}

void _thenEmailIsEmptyValidationErrorIsPresent() {
  expect(find.text('Email is required'), findsOneWidget);
}

void _thenEmailIsInvalidValidationErrorIsPresent() {
  expect(find.text('Please enter a valid email'), findsOneWidget);
}

void _thenLastNameIsInvalidValidationErrorIsPresent() {
  expect(find.text('Invalid characters'), findsOneWidget);
}

void _thenPasswordIsInvalidValidationErrorIsPresent() {
  expect(find.text(_localizedStrings.passwordInvalidError), findsOneWidget);
}

void _thenTermsOfUseErrorIsPresent() {
  expect(find.text(_localizedStrings.registerPageAgreeTermsOfUseError),
      findsOneWidget);
}

void _thenNoEmailValidationError() {
  expect(find.text('Email is required'), findsNothing);
  expect(find.text('Please enter a valid email'), findsNothing);
}

void _thenNoFirstNameValidationError() {
  expect(find.text('First name is required'), findsNothing);
  expect(find.text('First name is invalid'), findsNothing);
}

void _thenNoLastNameValidationError() {
  expect(find.text('Last name is required'), findsNothing);
  expect(find.text('Last name is invalid'), findsNothing);
}

void _thenNoPasswordValidationError() {
  expect(find.text('Password is required'), findsNothing);
  expect(
      find.text('The password should be at least 8 characters long '
          'containing one upper case, one number and '
          'one special sign (!@#\$%&).'),
      findsNothing);
}

void _thenNoTermsOfUseError() {
  expect(find.text(_localizedStrings.registerPageAgreeTermsOfUseError),
      findsNothing);
}

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.register(
    email: anyNamed('email'),
    password: anyNamed('password'),
    lastName: anyNamed('lastName'),
    firstName: anyNamed('firstName'),
    countryOfNationalityId: anyNamed('countryOfNationalityId'),
  ));
}

//endregion
//region HELPERS
Widget _getSubjectWidget(RegisterBloc registerBloc,
    PasswordValidationBloc mockPasswordValidationBloc) {
  final mockRegisterModule = MockRegisterModule();
  when(mockRegisterModule.registerBloc).thenReturn(registerBloc);
  when(mockRegisterModule.registerAnalyticsManager)
      .thenReturn(_mockRegisterAnalyticsManager);

  final mockPasswordValidationModule = MockPasswordValidationModule();
  when(mockPasswordValidationModule.passwordValidationBloc)
      .thenReturn(mockPasswordValidationBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    child: ModuleProvider<PasswordValidationModule>(
      module: mockPasswordValidationModule,
      child: ModuleProvider<RegisterModule>(
        module: mockRegisterModule,
        child: RegisterPage(),
      ),
    ),
  );
}
//endregion
