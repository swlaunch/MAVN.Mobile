import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/ui_components/amount_connversion_widget.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/ui_components/property_payment_amount_widget.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/redeem_transfer_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';

class PropertyPaymentForm extends HookWidget with FormMixin {
  PropertyPaymentForm({
    this.balance,
    this.spendRuleId,
    this.property,
    this.extendedInstalment,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey amountOfTokenGlobalKey = GlobalKey();

  final TokenCurrency balance;
  final String spendRuleId;
  final Property property;
  final ExtendedInstalmentModel extendedInstalment;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final analyticsManager = useRedeemTransferAnalyticsManager();

    final propertyPaymentBloc = usePropertyPaymentBloc();
    final propertyPaymentFormState =
        useBlocState<PropertyPaymentState>(propertyPaymentBloc);

    final spendRuleConversionRateBloc = useSpendRuleConversionRateBloc();
    final spendRuleConversionRateState =
        useBlocState<SpendRuleConversionRateState>(spendRuleConversionRateBloc);

    final propertyAmountBloc = usePropertyPaymentAmountBloc();
    final propertyAmountState = useBlocState(propertyAmountBloc);

    final mobileSettings =
        useState(useGetMobileSettingsUseCase(context).execute());

    final amountOfTokenTextEditingController = useCustomTextEditingController();

    final isFormSubmissionErrorDismissed = useState(false);

    final formAutoValidate = useState(false);

    final amountOfTokenFocusNode = useFocusNode();
    final fullAmountValidationManager = useFieldValidationManager([
      PaymentAmountRequiredFieldValidation(),
      PaymentAmountInvalidFieldValidation(),
      InsufficientBalanceFieldValidation(
        balance: balance.decimalValue,
      ),
      AmountSmallerOrEqualToInstalment(
        instalmentAmount:
            extendedInstalment.instalment.amountInTokens.decimalValue,
      ),
      AmountBiggerThanZero(),
    ]);

    final partialAmountValidationManager = useFieldValidationManager([
      PaymentAmountRequiredFieldValidation(),
      PaymentAmountInvalidFieldValidation(),
      MaximumDecimalPlacesFieldValidation(
          precision: mobileSettings.value?.tokenPrecision),
      InsufficientBalanceFieldValidation(
        balance: balance.decimalValue,
      ),
      AmountSmallerOrEqualToInstalment(
        instalmentAmount:
            extendedInstalment.instalment.amountInTokens.decimalValue,
      ),
      AmountBiggerThanZero(),
    ]);

    useBlocEventListener(propertyPaymentBloc, (event) {
      if (event is PropertyPaymentSuccessEvent) {
        router
          ..popToRoot()
          ..pushPropertyPaymentSuccessPage();
      }
      if (event is PropertyPaymentWalletDisabledEvent) {
        router.showWalletDisabledDialog();
      }
    });

    useEffect(() {
      spendRuleConversionRateBloc.getSpendRuleConversionRate(
        spendRuleId: spendRuleId,
        amountOfToken: '1',
      );
    }, [spendRuleConversionRateBloc]);

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      if (!formKey.currentState.validate()) {
        formAutoValidate.value = true;
        return;
      }

      if (propertyAmountState is PropertyPaymentSelectedAmountState) {
        dismissKeyboard(context);
        propertyPaymentBloc.sendPayment(
          id: extendedInstalment.instalment.id,
          instalmentName: extendedInstalment.instalment.name,
          spendRuleId: spendRuleId,
          amountInToken: amountOfTokenTextEditingController.text,
          amountInCurrency: extendedInstalment.instalment.amountInFiat,
          amountSize: propertyAmountState.amountSize,
        );
        analyticsManager.transferToken(
            businessVertical: OfferVertical.realEstate);
      }
    }

    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Form(
              key: formKey,
              autovalidate: formAutoValidate.value,
              child: Column(
                children: <Widget>[
                  PropertyPaymentAmountWidget(
                    label: useLocalizedStrings().transferTokenAmountLabel(
                        mobileSettings.value?.tokenSymbol),
                    hint: useLocalizedStrings().enterAmountHint,
                    focusNode: amountOfTokenFocusNode,
                    textEditingController: amountOfTokenTextEditingController,
                    fieldFullAmountValidationManager:
                        fullAmountValidationManager,
                    fieldPartialAmountValidationManager:
                        partialAmountValidationManager,
                    textInputAction: TextInputAction.done,
                    onKeyboardTextInputActionTappedSuccess: onSubmit,
                    globalKey: amountOfTokenGlobalKey,
                    amountValueKey: const Key('amountGlobalKey'),
                    details: spendRuleConversionRateState
                            is SpendRuleConversionRateLoadedState
                        ? AmountConversionWidget(
                            amountTextEditingController:
                                amountOfTokenTextEditingController,
                            rate: spendRuleConversionRateState.rate,
                            currencyName:
                                spendRuleConversionRateState.currencyCode,
                          )
                        : Container(),
                    fullAmount: extendedInstalment
                        .instalment.amountInTokens.nonCommaSeparatedValue,
                  ),
                  const SizedBox(height: 32),
                  if (propertyPaymentFormState
                      is PropertyPaymentInlineErrorState)
                    _buildInlineError(
                        propertyPaymentFormState.error.localize(useContext())),
                  _buildSubmitButton(
                    onSubmit: onSubmit,
                    isLoading:
                        propertyPaymentFormState is PropertyPaymentLoadingState,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (propertyPaymentFormState is PropertyPaymentErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                error: propertyPaymentFormState.error.localize(useContext()),
                onRetryTap: onSubmit,
                onCloseTap: () {
                  isFormSubmissionErrorDismissed.value = true;
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildError({
    String error,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: GenericErrorWidget(
            valueKey: const Key('propertyPaymentFormPageError'),
            text: error,
            onRetryTap: onRetryTap,
            onCloseTap: onCloseTap,
            margin: const EdgeInsets.only(bottom: 16),
          ));

  Widget _buildInlineError(String message) => InlineErrorWidget(
        keyValue: 'paymentFormError',
        errorMessage: message,
      );

  Widget _buildSubmitButton({
    @required VoidCallback onSubmit,
    @required bool isLoading,
  }) =>
      PrimaryButton(
          buttonKey: const Key('paymentFormSendButton'),
          text: useLocalizedStrings().transferTokensButton,
          onTap: onSubmit,
          isLoading: isLoading);
}
