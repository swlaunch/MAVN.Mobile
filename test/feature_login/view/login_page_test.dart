import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_login/anaytics/login_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_state.dart';
import 'package:lykke_mobile_mavn/feature_login/di/login_module.dart';
import 'package:lykke_mobile_mavn/feature_login/view/login_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';
import 'package:pedantic/pedantic.dart';

import '../../helpers/action_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

bool _unauthorizedRedirection;

WidgetTester _widgetTester;

MockLoginBloc _mockBloc;
Router _mockRouter;
LoginAnalyticsManager _mockLoginAnalyticsManager;
MockLoginFormBloc _mockLoginFormBloc;
RemoteConfigManager _mockRemoteConfigManager;

Widget _subjectWidget;

void main() {
  group('LoginPage tests', () {
    setUp(() {
      _mockRouter = MockRouter();
      _mockLoginAnalyticsManager = MockLoginAnalyticsManager();
      _mockRemoteConfigManager = MockRemoteConfigManager();
      _mockLoginFormBloc = MockLoginFormBloc(LoginFormUninitializedState());
      _unauthorizedRedirection = false;
    });

    testWidgets('LoginUninitializedState', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      _thenLoginSubmitButtonIsEnabled();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('LoginLoadingState', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginLoadingState(),
      );

      await _thenLoginSubmitButtonIsDisabled();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('LoginSuccessEvent', (widgetTester) async {
      final mockBiometricBloc =
          MockBiometricBloc(BiometricCannotAuthenticateState());

      await givenSubjectWidgetWithInitialBlocState(
          widgetTester, LoginLoadingState(),
          mockBiometricBloc: mockBiometricBloc);

      when(mockBiometricBloc.shouldAskUserToEnableBiometrics())
          .thenAnswer((_) => Future.value(false));

      await _mockBloc.testNewEvent(
        event: LoginSuccessEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.navigateToLandingPage()).called(1);
    });

    testWidgets('LoginErrorState', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      _thenLoginSubmitButtonIsEnabled();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
    });

    testWidgets('submit login valid email valid password',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenEnteredValidPassword();

      await widgetTester.tap(find.byKey(const Key('loginSubmitButton')));

      _thenBlocLoginCalled();
    });

    testWidgets('validate email - empty email validation error',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenLoginSubmitButtonTapped();
      _thenEmailIsEmptyValidationErrorIsPresent();
    });

    testWidgets('validate email - invalid email validation error',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidEmail();
      await whenLoginSubmitButtonTapped();

      _thenEmailIsInvalidValidationErrorIsPresent();
    });

    testWidgets('validate email - valid email validation error',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );
      await whenEnteredValidEmail();
      await whenLoginSubmitButtonTapped();

      _thenNoEmailValidationError();
    });

    testWidgets('validate password - empty password validation error',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );
      await whenLoginSubmitButtonTapped();

      _thenPasswordIsEmptyValidationErrorIsPresent();
    });

    testWidgets('validate password - invalid password, no validation error',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidPassword();
      await whenLoginSubmitButtonTapped();

      _thenNoPasswordValidationError();
    });

    testWidgets('auto validation - tapping login, auto validation on',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenLoginSubmitButtonTapped();

      _thenEmailIsEmptyValidationErrorIsPresent();
      _thenPasswordIsEmptyValidationErrorIsPresent();

      await whenEnteredValidEmail();
      await whenEnteredValidPassword();

      _thenNoEmailValidationError();
      _thenNoPasswordValidationError();
    });

    testWidgets(
        'email validation - invalid email, tapping next button on keyboard',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);

      _thenEmailIsInvalidValidationErrorIsPresent();
      _thenEmailFieldIsFocused(true);
      _thenPasswordFieldIsFocused(false);
    });

    testWidgets(
        'email validation - valid email, tapping next button on keyboard',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);

      _thenNoEmailValidationError();
      _thenEmailFieldIsFocused(false);
      _thenPasswordFieldIsFocused(true);
    });

    testWidgets(
        'password validation - empty password, tapping done button on keyboard',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredEmptyPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.done);

      _thenPasswordIsEmptyValidationErrorIsPresent();
      _thenEmailFieldIsFocused(false);
      _thenPasswordFieldIsFocused(true);
      _thenBlocNotCalled();
    });

    testWidgets(
        'password validation - valid password, invalid email, tapping '
        'done button on keyboard', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidEmail();
      await whenEnteredValidPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.done);

      _thenNoPasswordValidationError();
      _thenEmailIsInvalidValidationErrorIsPresent();
      _thenEmailFieldIsFocused(true);
      _thenPasswordFieldIsFocused(false);
      _thenBlocNotCalled();
    });

    testWidgets(
        'password validation - valid password, valid email, tapping '
        'done button on keyboard', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenEnteredValidPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.done);

      _thenNoEmailValidationError();
      _thenNoPasswordValidationError();
      _thenEmailFieldIsFocused(false);
      _thenPasswordFieldIsFocused(false);
      _thenBlocLoginCalled();
    });

    testWidgets('obscure password toggle', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      _thenPasswordFieldIsObscured(true);
      await whenObscurePasswordButtonTapped();

      _thenPasswordFieldIsObscured(false);
      await whenObscurePasswordButtonTapped();

      _thenPasswordFieldIsObscured(true);
    });

    testWidgets(
        'invalid email, invalid password, tapping submit button sends '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenLoginSubmitButtonTapped();

      verify(_mockLoginAnalyticsManager.submitButtonTapped()).called(1);
    });

    testWidgets(
        'valid email, valid password, tapping submit button sends '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenEnteredValidPassword();
      await whenLoginSubmitButtonTapped();

      verify(_mockLoginAnalyticsManager.submitButtonTapped()).called(1);
    });

    testWidgets(
        'invalid email, tapping email keyboard next button sends '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);

      verify(_mockLoginAnalyticsManager.emailKeyboardNextButtonTapped())
          .called(1);
    });

    testWidgets(
        'valid email, tapping email keyboard next button sends analytics event',
        (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);

      verify(_mockLoginAnalyticsManager.emailKeyboardNextButtonTapped())
          .called(1);
    });

    testWidgets(
        'valid email, invalid password, tapping password keyboard '
        'done button sends analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenEnteredInvalidPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.done);

      verify(_mockLoginAnalyticsManager.passwordKeyboardDoneButtonTapped())
          .called(1);
    });

    testWidgets(
        'valid email, valid password, tapping password keyboard done '
        'button sends analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredValidEmail();
      await whenEnteredValidPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.done);

      verify(_mockLoginAnalyticsManager.passwordKeyboardDoneButtonTapped())
          .called(1);
    });

    testWidgets(
        'invalid email, sends email invalid client validation error '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredInvalidEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);
      await whenLoginSubmitButtonTapped();
      await whenEnteredValidEmail();

      verify(_mockLoginAnalyticsManager.emailInvalidClientValidationError())
          .called(2);
    });

    testWidgets(
        'empty email, sends email empty client validation error '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredEmptyEmail();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);
      await whenLoginSubmitButtonTapped();
      await whenEnteredValidEmail();

      verify(_mockLoginAnalyticsManager.emailEmptyClientValidationError())
          .called(2);
    });

    testWidgets(
        'empty password, sends password empty client validation error '
        'analytics event', (widgetTester) async {
      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await whenEnteredEmptyPassword();
      await whenKeyboardTextInputActionTapped(TextInputAction.next);
      await whenLoginSubmitButtonTapped();
      await whenEnteredValidPassword();

      verify(_mockLoginAnalyticsManager.passwordEmptyClientValidationError())
          .called(2);
    });

    testWidgets('unauthorized redirection true', (widgetTester) async {
      _unauthorizedRedirection = true;

      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await widgetTester.pump();
      expect(find.byKey(const Key('unauthorizedRedirectionMessage')),
          findsOneWidget);
    });

    testWidgets('unauthorized redirection false', (widgetTester) async {
      _unauthorizedRedirection = false;

      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await widgetTester.pump();
      expect(find.byKey(const Key('unauthorizedRedirectionMessage')),
          findsNothing);
    });

    testWidgets(
        'unauthorized redirection rebuild widget does not trigger snackbar',
        (widgetTester) async {
      _unauthorizedRedirection = true;

      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginUninitializedState(),
      );

      await widgetTester.pump();
      expect(find.byKey(const Key('unauthorizedRedirectionMessage')),
          findsOneWidget);

      await _waitForSnackBarDismissed();

      expect(find.byKey(const Key('unauthorizedRedirectionMessage')),
          findsNothing);

      // Rebuild widget tree
      // TODO: Figure out a better way to do this
      unawaited(widgetTester.binding.reassembleApplication());
      await widgetTester.pumpAndSettle();

      await widgetTester.pump();
      expect(find.byKey(const Key('unauthorizedRedirectionMessage')),
          findsNothing);
    });

    testWidgets(
        'redirect to login page, with the welcome page as the root, '
        'if account is deactivated', (widgetTester) async {
      _unauthorizedRedirection = true;

      await givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        LoginLoadingState(),
      );

      await _mockBloc.testNewEvent(
        event: LoginErrorDeactivatedAccountEvent(),
        widgetTester: widgetTester,
      );

      await thenTheFollowingRoutesAreCalled([
        _mockRouter.pushRootWelcomePageForMultiPush,
        _mockRouter.pushLoginPageForMultiPush,
        _mockRouter.pushAccountDeactivatedPage
      ]);
    });
  });
}

//////// GIVEN //////////
Future<void> givenSubjectWidgetWithInitialBlocState(
    WidgetTester tester, LoginState blocState,
    {MockBiometricBloc mockBiometricBloc}) async {
  _mockBloc = MockLoginBloc(blocState);
  _subjectWidget = _getSubjectWidget(
    _mockBloc,
    biometricBloc:
        mockBiometricBloc ?? MockBiometricBloc(BiometricUninitializedState()),
  );

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
  _thenEmailFieldIsFocused(false);
  _thenPasswordFieldIsFocused(false);
}
//////// WHEN //////////

Future<void> whenKeyboardTextInputActionTapped(
    TextInputAction inputAction) async {
  await _widgetTester.testTextInput.receiveAction(inputAction);
  await _widgetTester.pumpAndSettle();
}

Future<void> whenLoginSubmitButtonTapped() async {
  await _widgetTester.tap(find.byKey(const Key('loginSubmitButton')));
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredInvalidEmail() async {
  await _widgetTester.enterText(
      find.byKey(const Key('emailTextField')), TestConstants.stubInvalidEmail);
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredEmptyEmail() async {
  await _widgetTester.enterText(find.byKey(const Key('emailTextField')), '');
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredEmptyPassword() async {
  await _widgetTester.enterText(find.byKey(const Key('passwordTextField')), '');
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredValidPassword() async {
  await _widgetTester.enterText(find.byKey(const Key('passwordTextField')),
      TestConstants.stubValidPassword);
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredValidEmail() async {
  await _widgetTester.enterText(
      find.byKey(const Key('emailTextField')), TestConstants.stubValidEmail);
  await _widgetTester.pumpAndSettle();
}

Future whenObscurePasswordButtonTapped() async {
  await _widgetTester.tap(find.byKey(const Key('obscurePasswordButton')));
  await _widgetTester.pumpAndSettle();
}

Future<void> whenEnteredInvalidPassword() async {
  await _widgetTester.enterText(
    find.byKey(const Key('passwordTextField')),
    TestConstants.stubInvalidPassword,
  );
  await _widgetTester.pumpAndSettle();
}

//////// THEN //////////
void _thenBlocLoginCalled() {
  final capturedArgs = verify(_mockBloc.login(captureAny, captureAny)).captured;

  expect(capturedArgs[0], TestConstants.stubValidEmail);
  expect(capturedArgs[1], TestConstants.stubValidPassword);
}

void _thenLoginSubmitButtonIsEnabled() {
  final loginSubmitFinder = find.byKey(const Key('loginSubmitButton'));
  expect(loginSubmitFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(loginSubmitFinder).onPressed,
    isNotNull,
  );
}

Future<void> _thenLoginSubmitButtonIsDisabled() async {
  final loginSubmitFinder = find.byKey(const Key('loginSubmitButton'));
  expect(loginSubmitFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(loginSubmitFinder).onPressed,
    isNull,
  );

  await _widgetTester.tap(loginSubmitFinder);
  verifyNever(_mockBloc.login(any, any));
}

void _thenPasswordFieldIsFocused(isFocused) {
  final passwordTextFieldFinder = find.descendant(
    of: find.byKey(const Key('passwordTextField')),
    matching: find.byType(TextField),
    matchRoot: true,
  );

  expect(
      _widgetTester
          .widget<TextField>(passwordTextFieldFinder)
          .focusNode
          .hasFocus,
      isFocused);
}

void _thenPasswordFieldIsObscured(isObscured) {
  final passwordTextFieldFinder = find.descendant(
    of: find.byKey(const Key('passwordTextField')),
    matching: find.byType(TextField),
    matchRoot: true,
  );

  expect(_widgetTester.widget<TextField>(passwordTextFieldFinder).obscureText,
      isObscured);
}

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

void _thenEmailIsEmptyValidationErrorIsPresent() {
  expect(find.text('Email is required'), findsOneWidget);
}

void _thenEmailIsInvalidValidationErrorIsPresent() {
  expect(find.text('Please enter a valid email'), findsOneWidget);
}

void _thenPasswordIsEmptyValidationErrorIsPresent() {
  expect(find.text('Password is required'), findsOneWidget);
}

void _thenNoEmailValidationError() {
  expect(find.text('Email is required'), findsNothing);
  expect(find.text('Please enter a valid email'), findsNothing);
}

void _thenNoPasswordValidationError() {
  expect(find.text('Password is required'), findsNothing);
  expect(
      find.text('The password should be at least 8 characters long '
          'containing one upper case, '
          'one number and one special sign (!@#\$%&).'),
      findsNothing);
}

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.login(any, any));
}
//////// HELPERS //////////

Widget _getSubjectWidget(LoginBloc loginBloc,
    {MockBiometricBloc biometricBloc}) {
  final mockLoginModule = MockLoginModule();
  when(mockLoginModule.loginAnalyticsManager)
      .thenReturn(_mockLoginAnalyticsManager);
  when(mockLoginModule.loginFormBloc).thenReturn(_mockLoginFormBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    mockRemoteConfigManager: _mockRemoteConfigManager,
    mockBiometricBloc: biometricBloc,
    mockLoginBloc: loginBloc,
    child: ModuleProvider<LoginModule>(
      module: mockLoginModule,
      child: LoginPage(
        unauthorizedInterceptorRedirection: _unauthorizedRedirection,
      ),
    ),
  );
}

Future<void> _waitForSnackBarDismissed() async {
  await _widgetTester.pump();
  await _widgetTester.pump(const Duration(milliseconds: 750));
  await _widgetTester.pump(const Duration(milliseconds: 750));
  await _widgetTester.pump(const Duration(milliseconds: 750));
  await _widgetTester.pump(const Duration(milliseconds: 750));
  await _widgetTester.pump(const Duration(milliseconds: 750));
  await _widgetTester.pump(const Duration(milliseconds: 1000));
  await _widgetTester.pump();
  await _widgetTester.pump(const Duration(milliseconds: 750));
}
