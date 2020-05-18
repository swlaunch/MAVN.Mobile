import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';

import 'change_password_form.dart';

class ChangePasswordPage extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordGlobalKey = GlobalKey();
  final _passwordGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final isFormSubmissionErrorDismissed = useState(false);
    final changePasswordBloc = useChangePasswordBloc();
    final changePasswordState =
        useBlocState<ChangePasswordState>(changePasswordBloc);
    final passwordController = useCustomTextEditingController();
    final confirmPasswordController = useCustomTextEditingController();

    useBlocEventListener(changePasswordBloc, (event) {
      if (event is ChangePasswordSuccessEvent) {
        router.replaceWithChangePasswordSuccessPage();
      }
    });

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      changePasswordBloc.changePassword(password: passwordController.text);
    }

    return DismissKeyboardOnTap(
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                PageTitle(
                  title: useLocalizedStrings().changePassword,
                  assetIconLeading: SvgAssets.settingsChangePassword,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          useLocalizedStrings().changePasswordPagePrompt,
                          style: TextStyles.darkBodyBody1RegularHigh,
                        ),
                        const SizedBox(height: 56),
                        ChangePasswordForm(
                          state: changePasswordState,
                          buttonText: useLocalizedStrings().changePassword,
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
            if (changePasswordState is ChangePasswordErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                error: changePasswordState.error.localize(useContext()),
                onRetryTap: onSubmit,
                onCloseTap: () {
                  isFormSubmissionErrorDismissed.value = true;
                },
              ),
          ],
        ),
      ),
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
            valueKey: const Key('changePasswordPageError'),
            text: error,
            onRetryTap: onRetryTap,
            onCloseTap: onCloseTap,
          ));
}
