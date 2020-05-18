import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

import 'friend_referral_form.dart';

class FriendReferralPage extends HookWidget with FormMixin {
  FriendReferralPage({@required this.extendedEarnRule});

  final ExtendedEarnRule extendedEarnRule;

  final _formKey = GlobalKey<FormState>();
  final _emailGlobalKey = GlobalKey();
  final _formFullNameContextGlobalKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final bloc = useFriendReferralBloc();
    final blocState = useBlocState<FriendReferralState>(bloc);
    final router = useRouter();
    final fullNameTextEditingController = useCustomTextEditingController();
    final emailController = useCustomTextEditingController();
    final isFormSubmissionErrorDismissed = useState(false);

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      bloc.submitFriendReferral(
        fullName: fullNameTextEditingController.text,
        email: emailController.text,
        earnRuleId: extendedEarnRule.id,
      );
    }

    useBlocEventListener(bloc, (event) {
      if (event is FriendReferralSubmissionSuccessEvent) {
        router.replaceWithFriendReferralSuccessPage();
      }
    });

    return GestureDetector(
      onTap: () {
        dismissKeyboard(context);
      },
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Heading(
                      useLocalizedStrings().inviteAFriend,
                      icon: SvgAssets.referrals,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: Text(
                        useLocalizedStrings().inviteAFriendPageDetails,
                        style: TextStyles.darkBodyBody1RegularHigh,
                      ),
                    ),
                    FriendReferralForm(
                      formKey: _formKey,
                      fullNameController: fullNameTextEditingController,
                      fullNameContextGlobalKey: _formFullNameContextGlobalKey,
                      emailContextGlobalKey: _emailGlobalKey,
                      emailController: emailController,
                      onSubmitTap: onSubmit,
                    )
                  ],
                ),
              ),
            ),
            if (blocState is FriendReferralSubmissionErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                  error: blocState.error,
                  canRetry: blocState.canRetry,
                  onRetryTap: onSubmit,
                  onCloseTap: () {
                    isFormSubmissionErrorDismissed.value = true;
                  }),
          ],
        ),
      ),
    );
  }

  Widget _buildError({
    LocalizedStringBuilder error,
    bool canRetry,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: GenericErrorWidget(
            valueKey: const Key('friendReferralPageError'),
            text: error.localize(useContext()),
            onRetryTap: canRetry ? onRetryTap : null,
            onCloseTap: onCloseTap,
          ));
}
