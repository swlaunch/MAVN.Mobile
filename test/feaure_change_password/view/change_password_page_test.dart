import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_change_password/di/change_password_module.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_form.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_page.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/di/password_validation_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockChangePasswordBloc _mockBloc;
MockPasswordValidationBloc _mockPasswordValidationBloc;
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();

Router _mockRouter;
WidgetTester _widgetTester;

Widget _subjectWidget;
FormHelper _formHelper;

const Key _passwordTextField = Key('passwordTextField');
const Key _confirmPasswordTextField = Key('confirmPasswordTextField');
const Key _changePasswordButton = Key('changePasswordSubmitButton');

final _localizedStrings = LocalizedStrings();

void main() {
  group('ChangePasswordPage tests', () {
    setUpAll(() {
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
    });

    testWidgets('ChangePasswordUnitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester, ChangePasswordUninitializedState());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(ChangePasswordForm), findsOneWidget);
    });

    testWidgets('ChangePasswordLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordLoadingState(),
      );

      await _thenChangePasswordSendButtonIsDisabled();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ChangePasswordInlineErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordInlineErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      expect(find.byType(InlineErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
    });

    testWidgets('ChangePasswordErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      expect(find.byType(GenericErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
    });

    testWidgets('ChangePasswordErrorState retry button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );
      await _whenIFillAllFieldsCorrectly();

      expect(find.byType(GenericErrorWidget), findsOneWidget);

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      _thenBlocCalled();
    });

    testWidgets('ChangePasswordSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: ChangePasswordSuccessEvent(),
        widgetTester: widgetTester,
      );

      expect(
          verify(_mockRouter.replaceWithChangePasswordSuccessPage()).callCount,
          1);
    });

    testWidgets('password valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.passwordInvalidCharactersClientSideValidationError,
        _localizedStrings.emptyPasswordClientSideValidationError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('password empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
          key: _passwordTextField, value: TestConstants.stubEmpty);
      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.emptyPasswordClientSideValidationError);
      _thenBlocNotCalled();
    });

    testWidgets('password invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubInvalidPassword,
      );
      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorsArePresent([
        _localizedStrings.passwordInvalidError,
        _localizedStrings.passwordsDoNotMatchClientSideValidationError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('password valid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          _localizedStrings.emptyPasswordClientSideValidationError,
          _localizedStrings.passwordInvalidCharactersClientSideValidationError,
        ])
        ..thenTextFieldIsNotFocused(key: _passwordTextField)
        ..thenTextFieldIsFocused(key: _confirmPasswordTextField);
      _thenBlocNotCalled();
    });

    testWidgets('password empty - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubEmpty,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.emptyPasswordClientSideValidationError)
        ..thenTextFieldIsFocused(key: _passwordTextField);
      _thenBlocNotCalled();
    });

    testWidgets('password invalid - next button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubInvalidPassword,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent(_localizedStrings.passwordInvalidError)
        ..thenTextFieldIsFocused(key: _passwordTextField);
      _thenBlocNotCalled();
    });

    testWidgets('confirm password valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenEnteredValue(
        key: _confirmPasswordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.passwordInvalidCharactersClientSideValidationError,
        _localizedStrings.emptyPasswordClientSideValidationError,
        _localizedStrings.passwordsDoNotMatchClientSideValidationError,
      ]);
      _thenBlocCalled();
    });

    testWidgets('password empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
          key: _passwordTextField, value: TestConstants.stubValidPassword);
      await _formHelper.whenEnteredValue(
          key: _confirmPasswordTextField, value: TestConstants.stubEmpty);

      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.passwordsDoNotMatchClientSideValidationError);
      _thenBlocNotCalled();
    });

    testWidgets('password invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );
      await _formHelper.whenEnteredValue(
          key: _passwordTextField, value: TestConstants.stubValidPassword);
      await _formHelper.whenEnteredValue(
        key: _confirmPasswordTextField,
        value: TestConstants.stubInvalidPassword,
      );

      await _formHelper.whenButtonTapped(_changePasswordButton);

      _formHelper.thenValidationErrorsArePresent([
        _localizedStrings.passwordsDoNotMatchClientSideValidationError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('password valid - done button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenEnteredValue(
        key: _confirmPasswordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.emptyPasswordClientSideValidationError,
        _localizedStrings.passwordInvalidCharactersClientSideValidationError,
        _localizedStrings.passwordsDoNotMatchClientSideValidationError
      ]);
      _thenBlocCalled();
    });

    testWidgets('confirm password empty - done button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubEmpty,
      );
      await _formHelper.whenEnteredValue(
        key: _confirmPasswordTextField,
        value: TestConstants.stubEmpty,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.emptyPasswordClientSideValidationError)
        ..thenTextFieldIsFocused(key: _passwordTextField);
      _thenBlocNotCalled();
    });

    testWidgets('confirm password invalid - done button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _passwordTextField,
        value: TestConstants.stubValidPassword,
      );
      await _formHelper.whenEnteredValue(
        key: _confirmPasswordTextField,
        value: TestConstants.stubInvalidPassword,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.passwordsDoNotMatchClientSideValidationError)
        ..thenTextFieldIsFocused(key: _confirmPasswordTextField);
      _thenBlocNotCalled();
    });

    testWidgets('ChangePasswordPage submit button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        ChangePasswordUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();
      await _formHelper.whenButtonTapped(_changePasswordButton);

      _thenBlocCalled();
    });
  });
}

//////// GIVEN //////////

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  ChangePasswordState blocState,
) async {
  _mockRouter = MockRouter();
  _mockBloc = MockChangePasswordBloc(blocState);
  _mockPasswordValidationBloc =
      MockPasswordValidationBloc(PasswordValidationUninitializedState());

  _subjectWidget = _getSubjectWidget(_mockBloc, _mockPasswordValidationBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(tester);

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// WHEN //////////

Future<void> _whenIFillAllFieldsCorrectly() async {
  await _formHelper.whenEnteredValue(
    key: _passwordTextField,
    value: TestConstants.stubValidPassword,
  );
  await _formHelper.whenEnteredValue(
    key: _confirmPasswordTextField,
    value: TestConstants.stubValidPassword,
  );
}

//////// THEN //////////

Future<void> _thenChangePasswordSendButtonIsDisabled() async {
  final registerSubmitFinder = find.byKey(_changePasswordButton);
  expect(registerSubmitFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(registerSubmitFinder).onPressed,
    isNull,
  );

  await _widgetTester.tap(registerSubmitFinder);
  verifyNever(_mockBloc.changePassword(password: anyNamed('password')));
}

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.changePassword(
    password: captureAnyNamed('password'),
  ));
}

void _thenBlocCalled() {
  final capturedArgs =
      verify(_mockBloc.changePassword(password: captureAnyNamed('password')))
          .captured;

  expect(capturedArgs[0], TestConstants.stubValidPassword);
}

//////// HELPERS //////////

Widget _getSubjectWidget(ChangePasswordBloc changePasswordBloc,
    PasswordValidationBloc mockPasswordValidationBloc) {
  final mockChangePasswordModule = MockChangePasswordModule();
  when(mockChangePasswordModule.changePasswordBloc)
      .thenReturn(changePasswordBloc);
  final mockPasswordValidationModule = MockPasswordValidationModule();
  when(mockPasswordValidationModule.passwordValidationBloc)
      .thenReturn(mockPasswordValidationBloc);
  return TestAppFrame(
    mockRouter: _mockRouter,
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    child: ModuleProvider<PasswordValidationModule>(
        module: mockPasswordValidationModule,
        child: ModuleProvider<ChangePasswordModule>(
          module: mockChangePasswordModule,
          child: ChangePasswordPage(),
        )),
  );
}
