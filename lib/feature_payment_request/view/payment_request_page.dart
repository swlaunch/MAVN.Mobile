import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/ui_components/payment_request_info_line.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/ui_components/payment_request_timer_widget.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_form.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/redeem_transfer_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class PaymentRequestPage extends HookWidget {
  PaymentRequestPage({
    this.paymentRequestId,
    this.fromPushNotification = false,
  });

  final String paymentRequestId;
  final bool fromPushNotification;

  final _formKey = GlobalKey<FormState>();
  final _amountGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final router = useRouter();
    final analyticsManager = useRedeemTransferAnalyticsManager();
    final paymentRequestDetailsBloc = usePaymentRequestDetailsBloc();
    final paymentRequestBloc = usePaymentRequestBloc();
    final paymentRequestDetailsBlocState =
        useBlocState(paymentRequestDetailsBloc);
    final paymentRequestBlocState = useBlocState(paymentRequestBloc);

    final tickerBloc = useTickerBloc();

    final amountTextEditingController = useCustomTextEditingController(
        text: paymentRequestDetailsBlocState is PaymentRequestDetailsLoadedState
            ? paymentRequestDetailsBlocState
                .payment.requestedAmountInTokens.nonCommaSeparatedValue
            : null);

    Future<bool> getConfirmationResult() async =>
        await router.showCustomDialog(
            title: useLocalizedStrings().warningDialogLeavingPageTitle,
            content: useLocalizedStrings().transferRequestRejectDialogText,
            positiveButtonText: useLocalizedStrings().warningDialogYesButton,
            negativeButtonText: useLocalizedStrings().warningDialogNoButton) ??
        false;

    void fetchPaymentRequest() {
      paymentRequestDetailsBloc.getPaymentRequest(
          paymentRequestId: paymentRequestId);
    }

    void approvePaymentRequest() {
      paymentRequestBloc.approvePaymentRequest(
          paymentRequestId: paymentRequestId,
          sendingAmount: amountTextEditingController.text);
      analyticsManager.transferToken(
          businessVertical: OfferVertical.hospitality);
    }

    Future<void> rejectPaymentRequest() async {
      final doCancel = await getConfirmationResult();
      if (doCancel) {
        await paymentRequestBloc.rejectPaymentRequest(
            paymentRequestId: paymentRequestId);
      }
    }

    void showRequestExpired() {
      router
        ..pop(true)
        ..pushPaymentRequestExpiredPage();
    }

    useEffect(() {
      fetchPaymentRequest();
    }, [paymentRequestDetailsBloc]);

    useBlocEventListener(tickerBloc, (event) {
      if (event is TickerFinishedEvent) {
        showRequestExpired();
      }
    });

    useBlocEventListener(paymentRequestBloc, (event) {
      if (event is PaymentRequestApprovedSuccessEvent) {
        router.replaceWithPaymentRequestApprovalSuccessPage();
      } else if (event is PaymentRequestRejectedSuccessEvent) {
        router.pop(true);
      } else if (event is PaymentRequestWalletDisabledEvent) {
        router.showWalletDisabledDialog();
      } else if (event is PaymentRequestExpiredEvent) {
        showRequestExpired();
      }
    });

    useBlocEventListener(paymentRequestDetailsBloc, (event) {
      if (event is PaymentRequestDetailsLoadedEvent) {
        tickerBloc.startTicker(
            durationInSeconds: event.payment.expirationTimeLeftInSeconds);
        if (fromPushNotification &&
            !StringUtils.isNullOrEmpty(event.payment.paymentInfo)) {
          router.showHotelPreCheckoutDialog(event.payment.paymentRequestId);
        }
      }
    });

    return ScaffoldWithAppBar(
      useDarkTheme: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: <Widget>[
                _buildTitleBox(
                  paymentRequestDetailsBlocState,
                  paymentRequestBlocState,
                  fetchPaymentRequest,
                ),
                if (paymentRequestDetailsBlocState
                    is PaymentRequestDetailsLoadedState)
                  _buildLoadedBody(
                    paymentRequestDetailsBlocState.payment,
                    paymentRequestBlocState,
                    amountTextEditingController,
                    approvePaymentRequest,
                    rejectPaymentRequest,
                    tokenSymbol.value,
                  ),
              ],
            ),
          ),
          if (paymentRequestDetailsBlocState is BaseDetailedErrorState ||
              paymentRequestBlocState is BaseDetailedErrorState)
            _buildError(
                paymentRequestDetailsBlocState is BaseDetailedErrorState
                    ? paymentRequestDetailsBlocState
                    : paymentRequestBlocState,
                fetchPaymentRequest),
          if (paymentRequestDetailsBlocState is BaseLoadingState ||
              paymentRequestBlocState is BaseLoadingState)
            const Center(
              child: Spinner(key: Key('paymentRequestPageLoadingSpinner')),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleBox(
    PaymentRequestDetailsState paymentRequestDetailsBlocState,
    PaymentRequestState paymentRequestBlocState,
    Function fetchPaymentRequest,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: ColorStyles.primaryDark,
        child: Column(
          children: <Widget>[
            if (paymentRequestDetailsBlocState
                is PaymentRequestDetailsLoadedState)
              Column(
                children: [
                  Row(
                    children: [
                      const StandardSizedSvg(
                        SvgAssets.hotels,
                        color: ColorStyles.white,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        useLocalizedStrings().transferRequestTitle,
                        style: TextStyles.lightHeadersH2,
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: DividerDecoration(color: ColorStyles.white)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          useLocalizedStrings().transferRequestIdHolder(
                              paymentRequestDetailsBlocState
                                  .payment.paymentRequestId),
                          style: TextStyles.lightBodyBody3Regular,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    useLocalizedStrings().transferRequestInfoHolder(
                        paymentRequestDetailsBlocState.payment.partnerName),
                    style: TextStyles.lightBodyBody2RegularHigh,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      );

  Widget _buildLoadedBody(
    PaymentRequestResponseModel paymentRequest,
    PaymentRequestState paymentRequestState,
    TextEditingController amountTextEditingController,
    VoidCallback onSubmitTap,
    VoidCallback onCancelTap,
    String tokenSymbol,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  color: ColorStyles.offWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentRequestInfoLine(
                          pairKey: useLocalizedStrings()
                              .transferRequestTotalBillLabel,
                          pairValue: useLocalizedStrings()
                              .transferRequestTotalBillHolder(
                                  paymentRequest.totalInToken.value,
                                  tokenSymbol,
                                  NumberFormatter.toFormattedStringFromDouble(
                                    paymentRequest.totalInCurrency,
                                  ),
                                  paymentRequest.currencyCode)),
                      PaymentRequestInfoLine(
                          pairKey: useLocalizedStrings()
                              .transferRequestWalletBalanceLabel,
                          pairValue: useLocalizedStrings().amountTokensHolder(
                              paymentRequest.walletBalance.value, tokenSymbol)),
                      PaymentRequestInfoLine(
                          pairKey: useLocalizedStrings()
                              .transferRequestRecipientLabel,
                          pairValue: paymentRequest.partnerName),
                      PaymentRequestTimerWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PaymentRequestForm(
              formKey: _formKey,
              amountGlobalKey: _amountGlobalKey,
              amountTextEditingController: amountTextEditingController,
              onSubmitTap: onSubmitTap,
              onCancelTap: onCancelTap,
              paymentRequest: paymentRequest,
            ),
          )
        ],
      );

  Widget _buildError(BaseDetailedErrorState baseErrorState,
          Function fetchPaymentRequest) =>
      Container(
          height: 200,
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          color: ColorStyles.primaryDark,
          child: GenericErrorIconWidget(
            errorKey: const Key('paymentRequestDetailsError'),
            title: baseErrorState.title.localize(useContext()),
            text: baseErrorState.subtitle.localize(useContext()),
            icon: baseErrorState.asset,
            onRetryTap: fetchPaymentRequest,
          ));
}
