import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/ui_components/amount_text_field.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_fee_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_fee_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/conversion_rate_info.dart';

class LinkedWalletSendForm extends HookWidget with FormMixin {
  LinkedWalletSendForm({
    @required this.formKey,
    @required this.amountGlobalKey,
    @required this.amountController,
    @required this.balance,
    @required this.formSubmitted,
    @required this.isLoading,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey amountGlobalKey;
  final TextEditingController amountController;
  final VoidCallback formSubmitted;
  final Decimal balance;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final linkedWalletSendFeeBloc = useLinkedWalletSendFeeBloc();
    final linkedWalletSendFeeState =
        useBlocState<LinkedWalletSendFeeState>(linkedWalletSendFeeBloc);

    final formAutoValidate = useState(false);
    final amountFocusNode = useFocusNode();

    useEffect(() {
      linkedWalletSendFeeBloc.fetchFee();
    }, [linkedWalletSendFeeBloc]);

    final amountValidationManager = useFieldValidationManager([
      PaymentAmountRequiredFieldValidation(),
      PaymentAmountInvalidFieldValidation(),
      InsufficientBalanceFieldValidation(balance: balance),
      AmountBiggerThanZero(),
    ]);

    void onFormSubmit() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: formSubmitted,
        validationManagers: [amountValidationManager],
        formKey: formKey,
      );
    }

    Widget _buildConversionRateInfo() {
      if (linkedWalletSendFeeState is LinkedWalletSendFeeLoadedState) {
        return ConversionRateInfo(
          amountTextEditingController: amountController,
          rate: linkedWalletSendFeeState.rate,
          currencyName: linkedWalletSendFeeState.baseCurrency,
          buildSuffix: (amount) => amount == null
              ? ' | ${useLocalizedStrings().feeLabel(linkedWalletSendFeeState.fee)}' // ignore: lines_longer_than_80_chars
              : '',
        );
      }
    }

    return Form(
        key: formKey,
        autovalidate: formAutoValidate.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: AmountTextField(
                  label: useLocalizedStrings().transferTokenAmountLabel(
                          tokenSymbol.value)
                      .toUpperCase(),
                  hint: useLocalizedStrings().enterAmountHint,
                  globalKey: amountGlobalKey,
                  amountValueKey: const Key('amountGlobalKey'),
                  focusNode: amountFocusNode,
                  details: _buildConversionRateInfo(),
                  textEditingController: amountController,
                  fieldValidationManager: amountValidationManager,
                  textInputAction: TextInputAction.done,
                  onKeyboardTextInputActionTappedSuccess: onFormSubmit),
            ),
            PrimaryButton(
              onTap: onFormSubmit,
              text: useLocalizedStrings().transferTokensButton,
              isLoading: isLoading,
            ),
            const SizedBox(height: 32)
          ],
        ));
  }
}
