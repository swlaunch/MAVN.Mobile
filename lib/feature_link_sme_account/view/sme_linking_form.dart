import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:tuple/tuple.dart';

class SmeLinkingForm extends HookWidget with FormMixin {
  const SmeLinkingForm({
    @required this.formKey,
    @required this.partnerCodeContextGlobalKey,
    @required this.partnerCodeController,
    @required this.linkingCodeContextGlobalKey,
    @required this.linkingCodeController,
    @required this.onSubmitTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey partnerCodeContextGlobalKey;
  final TextEditingController partnerCodeController;
  final GlobalKey linkingCodeContextGlobalKey;
  final TextEditingController linkingCodeController;
  final VoidCallback onSubmitTap;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final bloc = useSmeLinkingBloc();
    final blocState = useBlocState<SmeLinkingState>(bloc);

    final formAutoValidate = useState(false);

    final partnerCodeFocusNode = useFocusNode();
    final linkingCodeFocusNode = useFocusNode();

    final partnerCodeValidationManager = useFieldValidationManager([
      PartnerCodeRequiredFieldValidation(),
      PartnerCodeInvalidFieldValidation(),
    ]);

    final linkingCodeValidationManager = useFieldValidationManager([
      PartnerLinkingCodeRequiredFieldValidation(),
      PartnerLinkingCodeInvalidLengthFieldValidation(),
      PartnerLinkingCodeInvalidFieldValidation(),
    ]);

    void submitSmeLinking() {
      validateAndSubmit(
          autoValidate: formAutoValidate,
          context: context,
          onSubmit: onSubmitTap,
          validationManagers: [
            partnerCodeValidationManager,
            linkingCodeValidationManager,
          ],
          formKey: formKey,
          refocusAndEnsureVisible: true,
          focusNodeValidationManagerKeyTuples: [
            Tuple3(linkingCodeValidationManager, linkingCodeFocusNode,
                linkingCodeContextGlobalKey),
            Tuple3(partnerCodeValidationManager, partnerCodeFocusNode,
                partnerCodeContextGlobalKey),
          ]);
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FieldPadding(
            CustomTextField(
              label: localizedStrings.partnerCode,
              hint: localizedStrings.partnerCodeHint,
              contextGlobalKey: partnerCodeContextGlobalKey,
              focusNode: partnerCodeFocusNode,
              valueKey: const Key('partnerCodeTextField'),
              textEditingController: partnerCodeController,
              fieldValidationManager: partnerCodeValidationManager,
              nextFocusNode: linkingCodeFocusNode,
              textInputAction: TextInputAction.next,
            ),
          ),
          FieldPadding(
            CustomTextField(
              label: localizedStrings.linkingCode,
              hint: localizedStrings.linkingCodeHint,
              contextGlobalKey: linkingCodeContextGlobalKey,
              valueKey: const Key('linkingCodeTextField'),
              focusNode: linkingCodeFocusNode,
              textEditingController: linkingCodeController,
              fieldValidationManager: linkingCodeValidationManager,
              textInputAction: TextInputAction.done,
              onKeyboardTextInputActionTappedSuccess: submitSmeLinking,
            ),
          ),
          _buildSubmitButton(submitSmeLinking, blocState, localizedStrings),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(VoidCallback submitSmeLinkingFunction,
          SmeLinkingState blocState, LocalizedStrings localizedStrings) =>
      PrimaryButton(
        buttonKey: const Key('submitButton'),
        text: localizedStrings.submitButton,
        onTap: submitSmeLinkingFunction,
        isLoading: blocState is SmeLinkingSubmissionLoadingState,
      );
}
