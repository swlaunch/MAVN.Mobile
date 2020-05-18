import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/partner_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/ui_components/amount_text_field.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/styled_outline_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/conversion_rate_info.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:tuple/tuple.dart';

class PaymentRequestForm extends HookWidget with FormMixin {
  PaymentRequestForm({
    @required this.formKey,
    @required this.amountGlobalKey,
    @required this.amountTextEditingController,
    @required this.onSubmitTap,
    @required this.onCancelTap,
    @required this.paymentRequest,
    Key key,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final GlobalKey amountGlobalKey;
  final TextEditingController amountTextEditingController;
  final VoidCallback onSubmitTap;
  final VoidCallback onCancelTap;
  final PaymentRequestResponseModel paymentRequest;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final paymentRequestBloc = usePaymentRequestBloc();
    final paymentRequestState =
        useBlocState<PaymentRequestState>(paymentRequestBloc);

    final partnerConversionRateBloc = usePartnerConversionRateBloc();
    final partnerConversionRateState =
        useBlocState<PartnerConversionRateState>(partnerConversionRateBloc);

    final localSettingsRepository = useLocalSettingsRepository();

    final formAutoValidate = useState(false);

    final amountFocusNode = useFocusNode();

    final amountValidationManager = useFieldValidationManager([
      TransferAmountRequiredFieldValidation(),
      TransferAmountInvalidFieldValidation(),
      MaximumDecimalPlacesFieldValidation(
        precision: localSettingsRepository.getMobileSettings().tokenPrecision,
      ),
      InsufficientBalanceFieldValidation(
        balance: paymentRequest.walletBalance.decimalValue,
      ),
      AmountBiggerThanZero(),
      AmountSmallerOrEqualToBill(
        totalBill: paymentRequest.requestedAmountInTokens.decimalValue,
      )
    ]);

    useEffect(() {
      partnerConversionRateBloc.getPartnerConversionRate(
        partnerId: paymentRequest.partnerId,
        amountOfToken: '1',
      );
    }, [partnerConversionRateBloc]);

    void onSubmitButtonTap() {
      validateAndSubmit(
          autoValidate: formAutoValidate,
          context: context,
          onSubmit: onSubmitTap,
          validationManagers: [amountValidationManager],
          formKey: formKey,
          refocusAndEnsureVisible: true,
          focusNodeValidationManagerKeyTuples: [
            Tuple3(amountValidationManager, amountFocusNode, amountGlobalKey)
          ]);
    }

    return DismissKeyboardOnTap(
      child: Form(
        key: formKey,
        autovalidate: formAutoValidate.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FieldPadding(
              AmountTextField(
                label: useLocalizedStrings()
                    .transferRequestSendingAmountLabel(tokenSymbol.value),
                focusNode: amountFocusNode,
                textEditingController: amountTextEditingController,
                fieldValidationManager: amountValidationManager,
                textInputAction: TextInputAction.done,
                details: _buildConversionRateInfo(partnerConversionRateState),
                globalKey: amountGlobalKey,
                amountValueKey: const Key('paymentRequestFormAmount'),
                onKeyboardTextInputActionTappedSuccess: onSubmitButtonTap,
              ),
            ),
            if (paymentRequestState is PaymentRequestInlineErrorState)
              _buildInlineError(
                  paymentRequestState.error.localize(useContext())),
            _buildPaymentRequestButtons(
              onSubmitTap: onSubmitButtonTap,
              onCancelTap: onCancelTap,
              isLoading: paymentRequestState is PaymentRequestLoadingState,
              tokenSymbol: tokenSymbol.value,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionRateInfo(
      PartnerConversionRateState partnerConversionRateState) {
    if (partnerConversionRateState is PartnerConversionRateLoadedState) {
      return ConversionRateInfo(
        amountTextEditingController: amountTextEditingController,
        rate: partnerConversionRateState.rate,
        currencyName: partnerConversionRateState.currencyCode,
      );
    }

    return Container();
  }

  Widget _buildPaymentRequestButtons({
    @required VoidCallback onSubmitTap,
    @required VoidCallback onCancelTap,
    @required bool isLoading,
    @required String tokenSymbol,
  }) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: AbsorbPointer(
            absorbing: isLoading,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: StyledOutlineButton(
                    text: useLocalizedStrings().transferRequestRejectButton,
                    onTap: onCancelTap,
                    useDarkTheme: true,
                    key: const Key('paymentRequestCancelButton'),
                  ),
                ),
                const SizedBox(width: 24),
                Flexible(
                  child: PrimaryButton(
                    buttonKey: const Key('paymentRequestSubmitButton'),
                    text: useLocalizedStrings().sendTokensButton(tokenSymbol),
                    onTap: onSubmitTap,
                  ),
                ),
              ],
            )),
      );

  Widget _buildInlineError(String message) => InlineErrorWidget(
        keyValue: 'paymentRequestError',
        errorMessage: message,
      );
}
