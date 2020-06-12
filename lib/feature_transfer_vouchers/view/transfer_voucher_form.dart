import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:tuple/tuple.dart';

class TransferVoucherForm extends HookWidget with FormMixin {
  const TransferVoucherForm({
    @required this.formKey,
    @required this.receiverEmailGlobalKey,
    @required this.receiverEmailFieldKey,
    @required this.receiverEmailTextEditingController,
    @required this.onSendTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey receiverEmailGlobalKey;
  final GlobalKey receiverEmailFieldKey;
  final TextEditingController receiverEmailTextEditingController;
  final VoidCallback onSendTap;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

    final transferVoucherBloc = useTransferVoucherBloc();
    final transferVoucherState =
        useBlocState<TransferVoucherState>(transferVoucherBloc);

    final formAutoValidate = useState(false);
    final receiverEmailFocusNode = useFocusNode();

    final receiverEmailValidationManager = useFieldValidationManager([
      ReceiverEmailRequiredFieldValidation(),
      ReceiverEmailInvalidFieldValidation(),
    ]);

    void onSendButtonTap() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSendTap,
        validationManagers: [
          receiverEmailValidationManager,
        ],
        formKey: formKey,
        refocusAndEnsureVisible: true,
        focusNodeValidationManagerKeyTuples: [
          Tuple3(receiverEmailValidationManager, receiverEmailFocusNode,
              receiverEmailGlobalKey),
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
              label: localizedStrings.transferVoucherReceiverEmailAddressHint,
              hint: localizedStrings.emailAddressHint,
              valueKey: const Key('receiverEmailTextField'),
              contextGlobalKey: receiverEmailGlobalKey,
              fieldKey: receiverEmailFieldKey,
              focusNode: receiverEmailFocusNode,
              textEditingController: receiverEmailTextEditingController,
              fieldValidationManager: receiverEmailValidationManager,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onKeyboardTextInputActionTappedSuccess: onSendButtonTap,
            ),
            const SizedBox(height: 80),
            PrimaryButton(
              text: localizedStrings.sendVoucher,
              onTap: onSendButtonTap,
              isLoading: transferVoucherState is TransferVoucherLoadingState,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
