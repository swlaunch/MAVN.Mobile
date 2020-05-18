import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/di/transaction_form_module.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_balance_error_widget.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_form.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_form_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockTransactionFormBloc _mockBloc;
MockWalletBloc _mockWalletBloc;
MockTransactionFormAnalyticsManager _mockTransactionFormAnalyticsManager;

Router _mockRouter;
WidgetTester _widgetTester;

Widget _subjectWidget;
FormHelper _formHelper;

const Key _walletAddressTextField = Key('walletAddressTextField');
const Key _amountTextField = Key('amountTextField');
const Key _transactionFormSendButton = Key('transactionFormSendButton');
final _localizedStrings = LocalizedStrings();

WalletState _defaultWalletState = WalletLoadedState(
  wallet: WalletResponseModel(balance: TestConstants.stubTokenCurrency),
  externalBalanceInBaseCurrency: TestConstants.stubBalance,
  baseCurrencyCode: TestConstants.stubBaseCurrency,
);

void main() {
  group('TransactionFormPage tests', () {
    testWidgets('TransactionFormUnitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester, TransactionFormUninitializedState());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(TransactionBalanceErrorWidget), findsNothing);

      verify(_mockTransactionFormAnalyticsManager.transferFormStarted());
    });

    testWidgets('TransactionFormLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormLoadingState(),
      );

      await _thenTransactionFormSendButtonIsDisabled();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(TestConstants.stubErrorText), findsNothing);
    });

    testWidgets('TransactionFormInlineErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormInlineErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      expect(find.byType(InlineErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
    });

    testWidgets('TransactionFormErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      expect(find.byType(GenericErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
    });

    testWidgets('TransactionFormErrorState retry button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );
      await _whenIFillAllFieldsCorrectly();

      expect(find.byType(GenericErrorWidget), findsOneWidget);

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      _thenBlocTransactionFormCalled();
    });

    testWidgets('TransactionFormWalletBlockedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: TransactionFormWalletDisabledEvent(),
        widgetTester: widgetTester,
      );

      expect(verify(_mockRouter.showWalletDisabledDialog()).callCount, 1);
    });

    testWidgets('TransactionFormSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: TransactionFormSuccessEvent(),
        widgetTester: widgetTester,
      );

      expect(
          verify(_mockRouter.replaceWithTransactionSuccessPage()).callCount, 1);
    });

    testWidgets('WalletErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          TransactionFormUninitializedState(),
          WalletErrorState(
              errorMessage:
                  LocalizedStringBuilder.custom(TestConstants.stubEmpty)));
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(TransactionForm), findsNothing);
      expect(find.byType(TransactionBalanceErrorWidget), findsOneWidget);
    });

    testWidgets('WalletErrorState retry', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          TransactionFormUninitializedState(),
          WalletErrorState(
              errorMessage:
                  LocalizedStringBuilder.custom(TestConstants.stubEmpty)));

      expect(find.byType(TransactionBalanceErrorWidget), findsOneWidget);
      await _formHelper.whenButtonTapped(const Key('balanceErrorRetryButton'));

      verify(_mockWalletBloc.fetchWallet());
    });

    testWidgets('wallet address valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubValidEmail,
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.transactionEmptyAddressError,
        _localizedStrings.transactionInvalidAddressError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('wallet address empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
          key: _walletAddressTextField, value: TestConstants.stubEmpty);
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionEmptyAddressError);
      _thenBlocNotCalled();
    });

    testWidgets('wallet address invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionInvalidAddressError);
      _thenBlocNotCalled();
    });

    testWidgets('wallet address valid - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubValidEmail,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          _localizedStrings.transactionEmptyAddressError,
          _localizedStrings.transactionInvalidAddressError,
        ])
        ..thenTextFieldIsNotFocused(key: _walletAddressTextField)
        ..thenTextFieldIsFocused(key: _amountTextField);
      _thenBlocNotCalled();
    });

    testWidgets('wallet address empty - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubEmpty,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.transactionEmptyAddressError)
        ..thenTextFieldIsFocused(key: _walletAddressTextField);
      _thenBlocNotCalled();
    });

    testWidgets('wallet address invalid - next button tapped',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.next);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.transactionInvalidAddressError)
        ..thenTextFieldIsFocused(key: _walletAddressTextField);
      _thenBlocNotCalled();
    });

    testWidgets('amount valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubValidTransactionAmount.toString(),
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.transactionAmountRequiredError,
        _localizedStrings.transactionAmountInvalidError,
        _localizedStrings.transactionAmountGreaterThanBalanceError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('amount empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
          key: _amountTextField, value: TestConstants.stubEmpty);
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountRequiredError);
      _thenBlocNotCalled();
    });

    testWidgets('amount invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubInvalidAmount,
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountInvalidError);
      _thenBlocNotCalled();
    });

    testWidgets(
        'amount greater than balance - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubGreaterThanBalanceTransactionAmount.toString(),
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountGreaterThanBalanceError);
      _thenBlocNotCalled();
    });

    testWidgets('amount equal to balance - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubBalance.toString(),
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.transactionAmountRequiredError,
        _localizedStrings.transactionAmountInvalidError,
        _localizedStrings.transactionAmountGreaterThanBalanceError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('amount negative - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubNegativeAmount,
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper
        ..thenValidationErrorsAreNotPresent([
          _localizedStrings.transactionAmountRequiredError,
          _localizedStrings.transactionAmountInvalidError,
          _localizedStrings.transactionAmountGreaterThanBalanceError,
        ])
        ..thenValidationErrorIsPresent(
            _localizedStrings.transferRequestAmountIsZeroError);
      _thenBlocNotCalled();
    });

    testWidgets('amount valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubValidTransactionAmount.toString(),
      );
      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.transactionAmountRequiredError,
        _localizedStrings.transactionAmountInvalidError,
        _localizedStrings.transactionAmountGreaterThanBalanceError,
      ]);
      _thenBlocNotCalled();
    });

    testWidgets('amount empty - done button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubEmpty,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.transactionAmountRequiredError)
        ..thenTextFieldIsFocused(key: _amountTextField);
      _thenBlocNotCalled();
    });

    testWidgets('amount invalid - done button tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubInvalidAmount,
      );
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _formHelper
        ..thenValidationErrorIsPresent(
            _localizedStrings.transactionAmountInvalidError)
        ..thenTextFieldIsFocused(key: _amountTextField);
      _thenBlocNotCalled();
    });

    testWidgets('amount done text input action tapped', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );
      await _whenIFillAllFieldsCorrectly();
      await _formHelper.whenKeyboardTextInputActionTapped(TextInputAction.done);

      _thenBlocTransactionFormCalled();
    });

    testWidgets('TransactionFormPage submit button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();

      await widgetTester
          .ensureVisible(find.byKey(const Key('transactionFormSendButton')));
      await widgetTester
          .tap(find.byKey(const Key('transactionFormSendButton')));

      _thenBlocTransactionFormCalled();
      verify(_mockTransactionFormAnalyticsManager.transferFormSubmit());
    });

    testWidgets(
        'wallet address - submit button validation focuses first invalid field',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        TransactionFormUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _walletAddressTextField,
        value: TestConstants.stubInvalidEmail,
      );
      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubEmpty,
      );

      await _formHelper.whenButtonTapped(_transactionFormSendButton);

      _formHelper
        ..thenTextFieldIsFocused(key: _walletAddressTextField)
        ..thenTextFieldIsNotFocused(key: _amountTextField);
    });

    testWidgets('start scan - success', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        BarcodeUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: BarcodeScanSuccessEvent(TestConstants.stubBarcode),
        widgetTester: widgetTester,
      );

      _formHelper.thenTextFieldHasValue(
          key: _walletAddressTextField, value: TestConstants.stubBarcode);
    });

    testWidgets('start scan - permission error', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        BarcodeScanPermissionErrorState(
            LazyLocalizedStrings.barcodeScanPermissionError),
      );

      expect(find.byType(GenericErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.text(_localizedStrings.barcodeScanPermissionError),
          findsOneWidget);
    });

    testWidgets('start scan - permission error retry should call start scan',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        BarcodeScanPermissionErrorState(
            LazyLocalizedStrings.barcodeScanPermissionError),
      );

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      verify(_mockBloc.startScan()).called(1);
    });

    testWidgets('start scan - generic error', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        BarcodeScanPermissionErrorState(LazyLocalizedStrings.barcodeScanError),
      );

      expect(find.byType(GenericErrorWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.text(_localizedStrings.barcodeScanError), findsOneWidget);
    });

    testWidgets('start scan - generic error retry should call start scan',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        BarcodeScanPermissionErrorState(LazyLocalizedStrings.barcodeScanError),
      );

      await widgetTester
          .tap(find.byKey(const Key('genericErrorWidgetRetryButton')));
      verify(_mockBloc.startScan()).called(1);
    });
  });
}

//////// GIVEN //////////

Future<void> _givenSubjectWidgetWithInitialBlocState(
    WidgetTester tester, TransactionFormState blocState,
    [WalletState balanceState]) async {
  _mockRouter = MockRouter();
  _mockBloc = MockTransactionFormBloc(blocState);
  _mockWalletBloc = MockWalletBloc(balanceState ?? _defaultWalletState);
  _mockTransactionFormAnalyticsManager = MockTransactionFormAnalyticsManager();
  _subjectWidget = _getSubjectWidget(_mockBloc, _mockWalletBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(tester);

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// WHEN //////////

Future<void> _whenIFillAllFieldsCorrectly() async {
  await _formHelper.whenEnteredValue(
    key: _walletAddressTextField,
    value: TestConstants.stubValidEmail,
  );
  await _formHelper.whenEnteredValue(
    key: _amountTextField,
    value: TestConstants.stubValidTransactionAmount.toString(),
  );
}

//////// THEN //////////

Future<void> _thenTransactionFormSendButtonIsDisabled() async {
  final registerSubmitFinder =
      find.byKey(const Key('transactionFormSendButton'));
  expect(registerSubmitFinder, findsOneWidget);

  expect(
    _widgetTester.widget<RaisedButton>(registerSubmitFinder).onPressed,
    isNull,
  );

  await _widgetTester.tap(registerSubmitFinder);
  verifyNever(_mockBloc.postTransaction(
    walletAddress: captureAnyNamed('walletAddress'),
    amount: captureAnyNamed('amount'),
  ));
}

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.postTransaction(
    walletAddress: captureAnyNamed('walletAddress'),
    amount: captureAnyNamed('amount'),
  ));
}

void _thenBlocTransactionFormCalled() {
  final capturedArgs = verify(_mockBloc.postTransaction(
    walletAddress: captureAnyNamed('walletAddress'),
    amount: captureAnyNamed('amount'),
  )).captured;

  expect(capturedArgs[0], TestConstants.stubValidEmail);
  expect(capturedArgs[1], TestConstants.stubValidTransactionAmount);
}

//////// HELPERS //////////

Widget _getSubjectWidget(
    TransactionFormBloc transactionFormBloc, MockWalletBloc mockWalletBloc) {
  final mockTransactionFormModule = MockTransactionFormModule();

  when(mockTransactionFormModule.transactionFormBloc)
      .thenReturn(transactionFormBloc);
  when(mockTransactionFormModule.transactionFormAnalyticsManager)
      .thenReturn(_mockTransactionFormAnalyticsManager);

  return TestAppFrame(
    mockWalletBloc: mockWalletBloc,
    mockRouter: _mockRouter,
    child: ModuleProvider<TransactionFormModule>(
      module: mockTransactionFormModule,
      child: TransactionFormPage(),
    ),
  );
}
