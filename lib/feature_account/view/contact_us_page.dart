import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/debounced_ink_well.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/key_value_pair_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';

class ContactUsPage extends HookWidget {
  static const contactButtonThrottleInterval = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final externalRouter = useExternalRouter();
    final errorMessageState = useState<String>();
    final getMobileSettingsUseCase = useGetMobileSettingsUseCase(context);
    final contactPhoneNumberState = useState<String>(
        getMobileSettingsUseCase.execute()?.supportPhoneNumber);
    final contactEmailState =
        useState<String>(getMobileSettingsUseCase.execute()?.supportEmail);

    void onPhoneTap() {
      externalRouter.launchPhone(contactPhoneNumberState.value,
          onLaunchError: () => errorMessageState.value =
              useLocalizedStrings().contactUsLaunchContactNumberError);
    }

    void onEmailTap() {
      externalRouter.launchEmail(contactEmailState.value,
          onLaunchError: () => errorMessageState.value =
              useLocalizedStrings().contactUsLaunchContactEmailError);
    }

    Future<void> onWhatsAppTap() async {
      await externalRouter.pushWhatsApp(
          phone: contactPhoneNumberState.value,
          message: useLocalizedStrings().contactUsWhatsAppStartingMessage);
    }

    return ScaffoldWithAppBar(
      body: Column(
        children: [
          PageTitle(
            title: useLocalizedStrings().contactUsButton,
            assetIconLeading: SvgAssets.settingsContactUs,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPageContent(
                    contactNumber: contactPhoneNumberState.value,
                    email: contactEmailState.value,
                    onPhoneTap: onPhoneTap,
                    onEmailTap: onEmailTap,
                    onWhatsAppTap: onWhatsAppTap,
                  ),
                  const Spacer(),
                  if (errorMessageState.value != null)
                    InlineErrorWidget(
                      keyValue: 'contactNumberLauncherError',
                      errorMessage: errorMessageState.value,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({
    String contactNumber,
    String email,
    VoidCallback onPhoneTap,
    VoidCallback onEmailTap,
    VoidCallback onWhatsAppTap,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(useLocalizedStrings().contactUsPageDetail,
              style: TextStyles.darkBodyBody1RegularHigh),
          const SizedBox(height: 32),
          if (contactNumber != null)
            _ContactOptionRow(
                contactButtonThrottleInterval: contactButtonThrottleInterval,
                icon: SvgAssets.phone,
                title: useLocalizedStrings().contactUsPhoneNumber,
                text: contactNumber,
                onTap: onPhoneTap),
          const SizedBox(height: 32),
          if (email != null)
            _ContactOptionRow(
                contactButtonThrottleInterval: contactButtonThrottleInterval,
                icon: SvgAssets.email,
                title: useLocalizedStrings().contactUsEmail,
                text: email,
                onTap: onEmailTap),
          const SizedBox(height: 32),
          if (contactNumber != null)
            _ContactOptionRow(
                contactButtonThrottleInterval: contactButtonThrottleInterval,
                icon: SvgAssets.whatsAppIcon,
                title: useLocalizedStrings().contactUsWhatsApp,
                text: contactNumber,
                onTap: onWhatsAppTap),
        ],
      );
}

class _ContactOptionRow extends StatelessWidget {
  const _ContactOptionRow({
    @required this.contactButtonThrottleInterval,
    @required this.icon,
    @required this.title,
    @required this.text,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final Duration contactButtonThrottleInterval;
  final String icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DebouncedInkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(icon),
            const SizedBox(width: 16),
            KeyValuePairWidget(
              pairKey: title,
              valueStyle: TextStyles.linksTextLinkBold,
              pairValue: text,
            ),
          ],
        ),
        throttleInterval: contactButtonThrottleInterval,
      );
}
