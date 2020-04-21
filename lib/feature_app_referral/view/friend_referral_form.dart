import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:tuple/tuple.dart';

class FriendReferralForm extends HookWidget with FormMixin {
  const FriendReferralForm({
    @required this.formKey,
    @required this.fullNameContextGlobalKey,
    @required this.fullNameController,
    @required this.emailContextGlobalKey,
    @required this.emailController,
    @required this.onSubmitTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey fullNameContextGlobalKey;
  final TextEditingController fullNameController;
  final GlobalKey emailContextGlobalKey;
  final TextEditingController emailController;
  final VoidCallback onSubmitTap;

  @override
  Widget build(BuildContext context) {
    final bloc = useFriendReferralBloc();
    final blocState = useBlocState<FriendReferralState>(bloc);
    final formAutoValidate = useState(false);

    final fullNameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();

    final fullNameValidationManager = useFieldValidationManager([
      FullNameRequiredFieldValidation(),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(),
    ]);

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(),
      EmailInvalidFieldValidation(),
    ]);

    void submitFriendReferralFunction() {
      validateAndSubmit(
          autoValidate: formAutoValidate,
          context: context,
          onSubmit: onSubmitTap,
          validationManagers: [
            fullNameValidationManager,
            emailValidationManager,
          ],
          formKey: formKey,
          refocusAndEnsureVisible: true,
          focusNodeValidationManagerKeyTuples: [
            Tuple3(
                emailValidationManager, emailFocusNode, emailContextGlobalKey),
            Tuple3(fullNameValidationManager, fullNameFocusNode,
                fullNameContextGlobalKey),
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
              label: useLocalizedStrings().hotelReferralFullNameFieldLabel,
              hint: useLocalizedStrings().hotelReferralFullNameFieldHint,
              contextGlobalKey: fullNameContextGlobalKey,
              focusNode: fullNameFocusNode,
              valueKey: const Key('fullNameTextField'),
              textEditingController: fullNameController,
              fieldValidationManager: fullNameValidationManager,
              nextFocusNode: emailFocusNode,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          FieldPadding(
            CustomTextField(
              label: useLocalizedStrings().emailRequiredLabel,
              hint: useLocalizedStrings().emailAddressHint,
              contextGlobalKey: emailContextGlobalKey,
              valueKey: const Key('emailTextField'),
              focusNode: emailFocusNode,
              textEditingController: emailController,
              fieldValidationManager: emailValidationManager,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.none,
              onKeyboardTextInputActionTappedSuccess:
                  submitFriendReferralFunction,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          _buildSubmitButton(submitFriendReferralFunction, blocState),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    VoidCallback submitFriendReferralFunction,
    FriendReferralState blocState,
  ) =>
      PrimaryButton(
        buttonKey: const Key('submitButton'),
        text: useLocalizedStrings().submitButton,
        onTap: submitFriendReferralFunction,
        isLoading: blocState is FriendReferralSubmissionLoadingState,
      );
}
