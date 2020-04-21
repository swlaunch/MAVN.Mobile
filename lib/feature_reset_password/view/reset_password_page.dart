import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_output.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/view/reset_password_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class ResetPasswordPage extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final resetPasswordBloc = useResetPasswordBloc();
    final resetPasswordState =
        useBlocState<ResetPasswordState>(resetPasswordBloc);

    return AuthScaffold(
      hasBackButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Heading(
              useLocalizedStrings().resetPasswordTitle,
              endContent: resetPasswordState is ResetPasswordSentEmailState
                  ? SvgPicture.asset(SvgAssets.success)
                  : null,
              endContentAlignedToTitle: true,
              icon: SvgAssets.settingsChangePassword,
            ),
            const SizedBox(height: 16),
            Text(
              resetPasswordState is ResetPasswordSentEmailState
                  ? useLocalizedStrings().resetPasswordSentEmailHint
                  : useLocalizedStrings().resetPasswordSendLinkHint,
              textAlign: TextAlign.left,
              style: TextStyles.darkBodyBody1RegularHigh,
            ),
            const SizedBox(height: 24),
            ResetPasswordForm(
              formKey: _formKey,
              emailGlobalKey: _emailGlobalKey,
              resetPasswordBloc: resetPasswordBloc,
              resetPasswordState: resetPasswordState,
            ),
          ],
        ),
      ),
    );
  }
}
