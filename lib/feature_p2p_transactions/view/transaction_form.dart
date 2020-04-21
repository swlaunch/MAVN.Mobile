import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/decimal_text_input_formatter.dart';
import 'package:lykke_mobile_mavn/library_form/delimiter_text_input_formatter.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:tuple/tuple.dart';

class TransactionForm extends HookWidget with FormMixin {
  const TransactionForm({
    @required this.formKey,
    @required this.walletAddressGlobalKey,
    @required this.walletAddressFieldKey,
    @required this.amountGlobalKey,
    @required this.walletAddressTextEditingController,
    @required this.amountTextEditingController,
    @required this.onSendTap,
    @required this.balance,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey walletAddressGlobalKey;
  final GlobalKey walletAddressFieldKey;
  final GlobalKey amountGlobalKey;
  final TextEditingController walletAddressTextEditingController;
  final TextEditingController amountTextEditingController;
  final VoidCallback onSendTap;
  final TokenCurrency balance;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final transactionFormBloc = useTransactionFormBloc();
    final transactionFormState =
        useBlocState<TransactionFormState>(transactionFormBloc);

    final localSettingRepository = useLocalSettingsRepository();
    final formAutoValidate = useState(false);

    final walletAddressFocusNode = useFocusNode();
    final amountFocusNode = useFocusNode();

    final walletAddressValidationManager = useFieldValidationManager([
      WalletAddressRequiredFieldValidation(),
      WalletAddressInvalidFieldValidation(),
    ]);

    final amountValidationManager = useFieldValidationManager([
      TransferAmountRequiredFieldValidation(),
      TransferAmountInvalidFieldValidation(),
      AmountBiggerThanZero(),
      MaximumDecimalPlacesFieldValidation(
          precision: localSettingRepository.getMobileSettings().tokenPrecision),
      InsufficientBalanceFieldValidation(
        balance: balance.decimalValue,
      )
    ]);

    void onSendButtonTap() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSendTap,
        validationManagers: [
          walletAddressValidationManager,
          amountValidationManager
        ],
        formKey: formKey,
        refocusAndEnsureVisible: true,
        focusNodeValidationManagerKeyTuples: [
          Tuple3(walletAddressValidationManager, walletAddressFocusNode,
              walletAddressGlobalKey),
          Tuple3(amountValidationManager, amountFocusNode, amountGlobalKey),
        ],
      );
    }

    return DismissKeyboardOnTap(
      child: Form(
        key: formKey,
        autovalidate: formAutoValidate.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextField(
              label: useLocalizedStrings().transactionReceiverEmailAddressHint,
              hint: useLocalizedStrings().emailAddressHint,
              valueKey: const Key('walletAddressTextField'),
              contextGlobalKey: walletAddressGlobalKey,
              fieldKey: walletAddressFieldKey,
              focusNode: walletAddressFocusNode,
              textEditingController: walletAddressTextEditingController,
              fieldValidationManager: walletAddressValidationManager,
              nextFocusNode: amountFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: useLocalizedStrings().transactionAmountTokensLabel(
                  tokenSymbol.value),
              hint: useLocalizedStrings().transactionAmountOfTokensHint,
              valueKey: const Key('amountTextField'),
              contextGlobalKey: amountGlobalKey,
              focusNode: amountFocusNode,
              textEditingController: amountTextEditingController,
              fieldValidationManager: amountValidationManager,
              inputFormatters: [
                DecimalTextInputFormatter(
                    decimalRange: localSettingRepository
                        .getMobileSettings()
                        .tokenPrecision),
                DelimiterTextInputFormatter(),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onKeyboardTextInputActionTappedSuccess: onSendButtonTap,
            ),
            const SizedBox(height: 56),
            if (transactionFormState is TransactionFormInlineErrorState)
              _buildInlineError(
                  transactionFormState.error.localize(useContext())),
            _buildTransactionButton(
                onSendTap: onSendButtonTap,
                isLoading: transactionFormState is TransactionFormLoadingState,
                tokenSymbol: tokenSymbol.value),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionButton({
    @required VoidCallback onSendTap,
    @required bool isLoading,
    @required String tokenSymbol,
  }) =>
      PrimaryButton(
          buttonKey: const Key('transactionFormSendButton'),
          text: useLocalizedStrings().transactionFormPageTitle(tokenSymbol),
          onTap: onSendTap,
          isLoading: isLoading);

  Widget _buildInlineError(String message) => InlineErrorWidget(
        keyValue: 'transactionFormError',
        errorMessage: message,
      );
}
