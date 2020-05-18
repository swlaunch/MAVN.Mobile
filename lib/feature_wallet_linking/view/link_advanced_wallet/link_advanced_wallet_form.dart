import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_block.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/list_items.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_row_widget.dart';

class LinkingAdvancedWalletForm extends HookWidget with FormMixin {
  const LinkingAdvancedWalletForm({
    @required this.formKey,
    @required this.linkingCodeContextGlobalKey,
    @required this.publicAddressContextGlobalKey,
    @required this.linkingCodeController,
    @required this.publicAddressController,
    @required this.onSubmitTapped,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey linkingCodeContextGlobalKey;
  final GlobalKey publicAddressContextGlobalKey;
  final TextEditingController linkingCodeController;
  final TextEditingController publicAddressController;
  final VoidCallback onSubmitTapped;

  static const fifthElementPlaceholder = '5.';
  static const sixthElementPlaceholder = '6.';

  @override
  Widget build(BuildContext context) {
    final linkAdvancedWalletBloc = useLinkAdvancedWalletBloc();
    final linkAdvancedWalletState =
        useBlocState<LinkAdvancedWalletState>(linkAdvancedWalletBloc);

    final linkCodeBloc = useLinkCodeBloc();
    final linkCodeState = useBlocState<LinkCodeState>(linkCodeBloc);

    useEffect(() {
      linkCodeBloc.generateLinkCode();
    }, [linkAdvancedWalletBloc]);

    final linkCode =
        (linkCodeState is LinkCodeLoadedState) ? linkCodeState.linkCode : '';

    final formAutoValidate = useState(false);

    final linkingCodeFocusNode = useFocusNode();
    final publicAddressFocusNode = useFocusNode();

    final linkingCodeValidationManager =
        useFieldValidationManager([LinkingCodeRequiredFieldValidation()]);
    final publicAddressValidationManager =
        useFieldValidationManager([PublicAddressRequiredFieldValidation()]);

    void submitFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSubmitTapped,
        validationManagers: [
          linkingCodeValidationManager,
          publicAddressValidationManager,
        ],
        formKey: formKey,
      );
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OrderedListItems<Widget>(
            items: [
              if (linkCodeState is! LinkCodeErrorState)
                _buildCopyRow(
                    useLocalizedStrings().linkAdvancedWalletInstructionCopyCode,
                    linkCode,
                    linkCodeState is LinkCodeLoadingState),
              if (linkCodeState is LinkCodeErrorState)
                Expanded(
                  child: GenericErrorIconWidget(
                    onRetryTap: () => linkCodeBloc.generateLinkCode(),
                    title: useLocalizedStrings().genericErrorShort,
                    text: linkCodeState.message.localize(useContext()),
                    errorKey: const Key('linkingCodeErrorIcon'),
                  ),
                ),
              _buildListItem(
                  useLocalizedStrings().linkAdvancedWalletInstructionSwitchApp),
              _buildListItem(useLocalizedStrings()
                  .linkAdvancedWalletInstructionSignMessage),
              _buildListItem(useLocalizedStrings()
                  .linkAdvancedWalletInstructionCopySignature),
            ],
            numberStyle: TextStyles.darkBodyBody3Regular,
            type: OrderedListType.numbered,
            itemBuilder: (item) => item,
          ),
          _buildCodeSignatureTextField(
              useLocalizedStrings().linkAdvancedWalletInstructionPasteSignature,
              linkingCodeFocusNode,
              publicAddressFocusNode,
              linkingCodeValidationManager),
          _buildPublicAddressTextField(
              useLocalizedStrings().linkAdvancedWalletInstructionPublicAddress,
              publicAddressFocusNode,
              publicAddressValidationManager,
              submitFunction),
          _buildLinkWalletButton(
              onTap: submitFunction,
              isLoading:
                  linkAdvancedWalletState is LinkAdvancedWalletLoadingState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildListItem(String instruction) => Text(
        instruction,
        style: TextStyles.darkBodyBody3Regular,
      );

  Widget _buildCopyRow(String instruction, String linkCode, bool isLoading) =>
      Expanded(
        child: CopyRowWidget(
          title: instruction,
          copyText: linkCode,
          isLoading: isLoading,
          styledToastPosition: StyledToastPosition.bottom,
        ),
      );

  Widget _buildCodeSignatureTextField(
          String instruction,
          FocusNode linkingCodeFocusNode,
          FocusNode publicAddressFocusNode,
          FieldValidationManager linkingCodeValidationManager) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          _buildListItem('$fifthElementPlaceholder $instruction'),
          const SizedBox(height: 32),
          CustomTextField(
            label: useLocalizedStrings()
                .linkAdvancedWalletTextFieldCodeSignatureTitle
                .toUpperCase(),
            hint: useLocalizedStrings()
                .linkAdvancedWalletTextFieldCodeSignatureHint,
            contextGlobalKey: linkingCodeContextGlobalKey,
            valueKey: const Key('linkingCodeTextField'),
            focusNode: linkingCodeFocusNode,
            nextFocusNode: publicAddressFocusNode,
            textEditingController: linkingCodeController,
            fieldValidationManager: linkingCodeValidationManager,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
        ],
      );

  Widget _buildPublicAddressTextField(
          String instruction,
          FocusNode publicAddressFocusNode,
          FieldValidationManager publicAddressValidationManager,
          VoidCallback onSubmit) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          _buildListItem('$sixthElementPlaceholder $instruction'),
          const SizedBox(height: 16),
          CustomTextField(
              label: useLocalizedStrings()
                  .linkAdvancedWalletTextFieldPublicAddressTitle
                  .toUpperCase(),
              hint: useLocalizedStrings()
                  .linkAdvancedWalletTextFieldPublicAddressHint,
              contextGlobalKey: publicAddressContextGlobalKey,
              valueKey: const Key('publicAddressTextField'),
              focusNode: publicAddressFocusNode,
              textEditingController: publicAddressController,
              fieldValidationManager: publicAddressValidationManager,
              textInputAction: TextInputAction.done,
              onKeyboardTextInputActionTappedSuccess: onSubmit),
          const SizedBox(height: 24),
        ],
      );

  Widget _buildLinkWalletButton(
          {@required VoidCallback onTap, @required bool isLoading}) =>
      PrimaryButton(
          text: useLocalizedStrings().linkAdvancedWalletButton,
          onTap: onTap,
          isLoading: isLoading);
}
