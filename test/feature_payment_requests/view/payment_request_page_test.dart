import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/partner_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/di/payment_request_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_form.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_page.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/transfer_module.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_ticker/di/ticker_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockPaymentRequestBloc _mockBloc;
MockPaymentRequestDetailsBloc _mockDetailsBloc;
MockPartnerConversionRateBloc _partnerConversionRateBloc;
MockTickerBloc _mockTickerBloc;
MockRedeemTransferAnalyticsManager mockRedeemTransferAnalyticsManager;

Router _mockRouter;
WidgetTester _widgetTester;

Widget _subjectWidget;
FormHelper _formHelper;

const Key _amountTextField = Key('paymentRequestFormAmount');

const Key _submitButton = Key('paymentRequestSubmitButton');

const Key _cancelButton = Key('paymentRequestCancelButton');

final _localizedStrings = LocalizedStrings();

final _defaultPaymentRequestDetailsState = PaymentRequestDetailsLoadedState(
  payment: TestConstants.stubPaymentRequest,
);

void main() {
  group('PaymentRequestPage tests', () {
    testWidgets('PaymentRequestUnitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          PaymentRequestUninitializedState(),
          PaymentRequestDetailsUninitializedState());

      expect(find.byType(Spinner), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(GenericErrorIconWidget), findsNothing);
      expect(find.byType(PaymentRequestForm), findsNothing);
    });

    testWidgets('PaymentRequestDetailsLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
        PaymentRequestDetailsLoadingState(),
      );

      expect(find.byType(Spinner), findsOneWidget);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(GenericErrorIconWidget), findsNothing);
      expect(find.byType(PaymentRequestForm), findsNothing);
    });
    testWidgets('PaymentRequestLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestLoadingState(),
      );

      expect(find.byType(Spinner), findsOneWidget);
      expect(find.byType(InlineErrorWidget), findsNothing);
      expect(find.byType(GenericErrorIconWidget), findsNothing);
    });

    testWidgets('PaymentRequestInlineErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestInlineErrorState(
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      );

      expect(find.byType(InlineErrorWidget), findsOneWidget);
      expect(find.byType(Spinner), findsNothing);
      expect(find.byType(GenericErrorIconWidget), findsNothing);
    });

    testWidgets('PaymentRequestDetailsErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
        PaymentRequestDetailsErrorState(
          errorTitle:
              LocalizedStringBuilder.custom(TestConstants.stubErrorText),
          errorSubtitle:
              LocalizedStringBuilder.custom(TestConstants.stubErrorText),
          iconAsset: SvgAssets.genericError,
        ),
      );

      expect(find.byType(GenericErrorIconWidget), findsOneWidget);
      expect(find.byType(Spinner), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
    });

    testWidgets('PaymentRequestErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestErrorState(
          errorTitle:
              LocalizedStringBuilder.custom(TestConstants.stubErrorText),
          errorSubtitle:
              LocalizedStringBuilder.custom(TestConstants.stubErrorText),
          iconAsset: SvgAssets.genericError,
        ),
      );

      expect(find.byType(GenericErrorIconWidget), findsOneWidget);
      expect(find.byType(Spinner), findsNothing);
      expect(find.byType(InlineErrorWidget), findsNothing);
    });

    testWidgets('PaymentRequestApprovalSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: PaymentRequestApprovedSuccessEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.replaceWithPaymentRequestApprovalSuccessPage())
          .called(1);
    });

    testWidgets('PaymentRequestRejectionSuccessEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: PaymentRequestRejectedSuccessEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.pop(true)).called(1);
    });

    testWidgets('PaymentRequestWalletDisabledEvent', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _mockBloc.testNewEvent(
        event: PaymentRequestWalletDisabledEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.showWalletDisabledDialog()).called(1);
    });

    testWidgets('PaymentRequestDetailsErrorState retry', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          PaymentRequestUninitializedState(),
          PaymentRequestDetailsErrorState(
              errorTitle:
                  LocalizedStringBuilder.custom(TestConstants.stubEmpty),
              errorSubtitle:
                  LocalizedStringBuilder.custom(TestConstants.stubEmpty),
              iconAsset: SvgAssets.error));

      expect(find.byType(GenericErrorIconWidget), findsOneWidget);
      await _formHelper
          .whenButtonTapped(const Key('genericErrorIconWidgetRetryButton'));

      verify(_mockDetailsBloc.getPaymentRequest(
          paymentRequestId: anyNamed('paymentRequestId')));
    });

    testWidgets('amount empty - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
          key: _amountTextField, value: TestConstants.stubEmpty);
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountRequiredError);
      _thenBlocNotCalled();
    });

    testWidgets('amount invalid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubInvalidAmount,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountInvalidError);
      _thenBlocNotCalled();
    });

    testWidgets(
        'amount greater than balance - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          PaymentRequestUninitializedState(),
          PaymentRequestDetailsLoadedState(
              payment: TestConstants.stubPaymentRequestInsufficientBalance));

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubPaymentRequestBalance.toString(),
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent(
          _localizedStrings.transactionAmountGreaterThanBalanceError);
      _thenBlocNotCalled();
    });

    testWidgets('amount greater than bill - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants.stubPaymentRequestTotalInTokenGreaterThanBill,
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorIsPresent(_localizedStrings
          .transferRequestAmountExceedsRequestedError(TestConstants
              .stubPaymentRequest.requestedAmountInTokens.decimalValue
              .toString()));
      _thenBlocNotCalled();
    });

    testWidgets('amount valid - validation after pressing submit',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _formHelper.whenEnteredValue(
        key: _amountTextField,
        value: TestConstants
            .stubPaymentRequest.requestedAmountInTokens.decimalValue
            .toString(),
      );
      await _formHelper.whenButtonTapped(_submitButton);

      _formHelper.thenValidationErrorsAreNotPresent([
        _localizedStrings.transactionAmountRequiredError,
        _localizedStrings.transactionAmountInvalidError,
        _localizedStrings.transactionAmountGreaterThanBalanceError,
        _localizedStrings.transferRequestAmountExceedsRequestedError(
            TestConstants
                .stubPaymentRequest.requestedAmountInTokens.decimalValue
                .toString()),
      ]);
      _thenBlocForApprovalCalled();
      _thenAnalyticsEventSent();
    });

    testWidgets('PaymentRequestPage submit button calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      await _whenIFillAllFieldsCorrectly();

      await widgetTester.ensureVisible(find.byKey(_submitButton));
      await widgetTester.tap(find.byKey(_submitButton));

      _thenBlocForApprovalCalled();
      _thenAnalyticsEventSent();
    });

    testWidgets(
        'PaymentRequestPage cancel and then cancelling does not call bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      when(_mockRouter.showCustomDialog(
              title: anyNamed('title'),
              content: anyNamed('content'),
              positiveButtonText: anyNamed('positiveButtonText'),
              negativeButtonText: anyNamed('negativeButtonText')))
          .thenAnswer((_) => Future.value(false));

      await widgetTester.ensureVisible(find.byKey(_cancelButton));
      await widgetTester.tap(find.byKey(_cancelButton));

      verify(_mockRouter.showCustomDialog(
              title: _localizedStrings.warningDialogLeavingPageTitle,
              content: _localizedStrings.transferRequestRejectDialogText,
              positiveButtonText: _localizedStrings.warningDialogYesButton,
              negativeButtonText: _localizedStrings.warningDialogNoButton))
          .called(1);
      await widgetTester.pumpAndSettle();
      verifyNever(_mockRouter.pop());
      _thenBlocNotCalled();
    });

    testWidgets('PaymentRequestPage cancel and then confirming calls bloc',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        PaymentRequestUninitializedState(),
      );

      when(_mockRouter.showCustomDialog(
              title: anyNamed('title'),
              content: anyNamed('content'),
              positiveButtonText: anyNamed('positiveButtonText'),
              negativeButtonText: anyNamed('negativeButtonText')))
          .thenAnswer((_) => Future.value(true));

      await widgetTester.ensureVisible(find.byKey(_cancelButton));
      await widgetTester.tap(find.byKey(_cancelButton));

      verify(_mockRouter.showCustomDialog(
              title: _localizedStrings.warningDialogLeavingPageTitle,
              content: _localizedStrings.transferRequestRejectDialogText,
              positiveButtonText: _localizedStrings.warningDialogYesButton,
              negativeButtonText: _localizedStrings.warningDialogNoButton))
          .called(1);

      _thenBlocForRejectionCalled();

      await _mockBloc.testNewEvent(
        event: PaymentRequestRejectedSuccessEvent(),
        widgetTester: widgetTester,
      );

      verify(_mockRouter.pop(true));
    });

    testWidgets('payment request expires', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          PaymentRequestUninitializedState(),
          PaymentRequestDetailsLoadedState(
            payment: TestConstants.stubPaymentRequest,
          ));

      await _mockTickerBloc.testNewEvent(
        event: TickerFinishedEvent(),
        widgetTester: widgetTester,
      );
      verify(_mockRouter.pushPaymentRequestExpiredPage()).called(1);
    });
  });
}

//////// GIVEN //////////

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester,
  PaymentRequestState blocState, [
  PaymentRequestDetailsState detailsState,
  PartnerConversionRateState partnerConversionRateState,
  TickerState tickerState,
]) async {
  _mockRouter = MockRouter();
  _mockBloc = MockPaymentRequestBloc(blocState);
  _mockDetailsBloc = MockPaymentRequestDetailsBloc(
      detailsState ?? _defaultPaymentRequestDetailsState);
  _partnerConversionRateBloc = MockPartnerConversionRateBloc(
      partnerConversionRateState ?? PartnerConversionRateUninitializedState());
  _mockTickerBloc = MockTickerBloc(tickerState ?? TickerUninitializedState());
  _subjectWidget = _getSubjectWidget(
      _mockBloc, _mockDetailsBloc, _partnerConversionRateBloc, _mockTickerBloc);

  _widgetTester = tester;

  _formHelper = FormHelper(tester);

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// WHEN //////////

Future<void> _whenIFillAllFieldsCorrectly() async {
  await _formHelper.whenEnteredValue(
    key: _amountTextField,
    value: TestConstants.stubPaymentRequest.requestedAmountInTokens.decimalValue
        .toString(),
  );
}

//////// THEN //////////

void _thenBlocNotCalled() {
  verifyNever(_mockBloc.approvePaymentRequest(
    paymentRequestId: anyNamed('paymentRequestId'),
    sendingAmount: anyNamed('sendingAmount'),
  ));
  verifyNever(_mockBloc.rejectPaymentRequest(
      paymentRequestId: anyNamed('paymentRequestId')));
}

void _thenBlocForApprovalCalled() {
  final capturedArgs = verify(_mockBloc.approvePaymentRequest(
    paymentRequestId: captureAnyNamed('paymentRequestId'),
    sendingAmount: captureAnyNamed('sendingAmount'),
  )).captured;

  expect(capturedArgs[0], TestConstants.stubPaymentRequestId);
  expect(
      capturedArgs[1],
      TestConstants.stubPaymentRequest.requestedAmountInTokens.decimalValue
          .toString());
}

void _thenAnalyticsEventSent() {
  verify(mockRedeemTransferAnalyticsManager.transferToken(
          businessVertical: OfferVertical.hospitality))
      .called(1);
}

void _thenBlocForRejectionCalled() {
  final capturedArgs = verify(_mockBloc.rejectPaymentRequest(
          paymentRequestId: captureAnyNamed('paymentRequestId')))
      .captured;

  expect(capturedArgs[0], TestConstants.stubPaymentRequestId);
}

//////// HELPERS //////////

Widget _getSubjectWidget(
  PaymentRequestBloc paymentRequestBloc,
  PaymentRequestDetailsBloc paymentRequestDetailsBloc,
  PartnerConversionRateBloc partnerConversionRateBloc,
  TickerBloc tickerBloc,
) {
  final mockPaymentRequestModule = MockPaymentRequestModule();

  when(mockPaymentRequestModule.paymentRequestBloc)
      .thenReturn(paymentRequestBloc);
  when(mockPaymentRequestModule.paymentRequestDetailsBloc)
      .thenReturn(paymentRequestDetailsBloc);
  when(mockPaymentRequestModule.partnerConversionRateBloc)
      .thenReturn(partnerConversionRateBloc);

  final mockTickerModule = MockTickerModule();
  when(mockTickerModule.tickerBloc).thenReturn(tickerBloc);

  final mockTransferModule = MockRedeemTransferModule();

  mockRedeemTransferAnalyticsManager = MockRedeemTransferAnalyticsManager();
  when(mockTransferModule.redeemTransferAnalyticsManager)
      .thenReturn(mockRedeemTransferAnalyticsManager);

  return TestAppFrame(
    mockRouter: _mockRouter,
    child: ModuleProvider<RedeemTransferModule>(
      module: mockTransferModule,
      child: ModuleProvider<TickerModule>(
        module: mockTickerModule,
        child: ModuleProvider<PaymentRequestModule>(
          module: mockPaymentRequestModule,
          child: PaymentRequestPage(
              paymentRequestId: TestConstants.stubPaymentRequestId),
        ),
      ),
    ),
  );
}
