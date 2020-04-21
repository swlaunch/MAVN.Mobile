import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_form.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class SetPasswordPage extends HookWidget {
  SetPasswordPage({@required this.email, @required this.resetIdentifier});

  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordGlobalKey = GlobalKey();
  final _passwordGlobalKey = GlobalKey();

  final String email;
  final String resetIdentifier;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final isFormSubmissionErrorDismissed = useState(false);
    final resetPasswordBloc = useResetPasswordBloc();
    final resetPasswordState =
        useBlocState<ResetPasswordState>(resetPasswordBloc);
    final passwordController = useCustomTextEditingController();
    final confirmPasswordController = useCustomTextEditingController();

    useBlocEventListener(resetPasswordBloc, (event) {
      if (event is ResetPasswordChangedEvent) {
        router.replaceWithSetPasswordSuccessPage();
      }
    });

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      resetPasswordBloc.changePassword(
        email: email,
        resetIdentifier: resetIdentifier,
        password: confirmPasswordController.text,
      );
    }

    return DismissKeyboardOnTap(
      child: AuthScaffold(
        hasBackButton: true,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Heading(useLocalizedStrings().resetPassword),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      useLocalizedStrings().resetPasswordPrompt,
                      style: TextStyles.darkBodyBody1RegularHigh,
                    ),
                    const SizedBox(height: 56),
                    ChangePasswordForm(
                      state: resetPasswordState,
                      buttonText: useLocalizedStrings().resetPassword,
                      formKey: _formKey,
                      passwordGlobalKey: _passwordGlobalKey,
                      confirmPasswordGlobalKey: _confirmPasswordGlobalKey,
                      passwordTextEditingController: passwordController,
                      confirmPasswordTextEditingController:
                          confirmPasswordController,
                      onSubmitTap: onSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
