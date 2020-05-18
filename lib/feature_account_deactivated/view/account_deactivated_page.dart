import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';

class AccountDeactivatedPage extends HookWidget {
  static const contactButtonThrottleInterval = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final externalRouter = useExternalRouter();
    final getMobileSettingsUseCase = useGetMobileSettingsUseCase(context);
    final contactPhoneNumberState = useState<String>(
        getMobileSettingsUseCase.execute()?.supportPhoneNumber);
    final errorMessageState = useState<String>();

    return ScaffoldWithAppBar(
      body: Column(
        children: [
          PageTitle(
            title: useLocalizedStrings().accountDeactivatedPageTitle,
            assetIconLeading: SvgAssets.accountDeactivated,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildPageContent(contactPhoneNumberState.value),
                  const Spacer(),
                  if (errorMessageState.value != null)
                    InlineErrorWidget(
                      keyValue: 'contactNumberLauncherError',
                      errorMessage: errorMessageState.value,
                    ),
                  PrimaryButton(
                    text: useLocalizedStrings()
                        .accountDeactivatedPageContactButton,
                    onTap: () {
                      externalRouter.launchPhone(contactPhoneNumberState.value,
                          onLaunchError: () {
                        errorMessageState.value = useLocalizedStrings()
                            .accountDeactivatedLaunchContactNumberError;
                      });
                    },
                    throttleInterval: contactButtonThrottleInterval,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPageContent(String contactNumberUrl) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 22),
        _buildStyledText(
            useLocalizedStrings().accountDeactivatedPageMessagePart1),
        const SizedBox(height: 16),
        _buildStyledText(useLocalizedStrings()
            .accountDeactivatedPageMessagePart2(Configuration.appName)),
        const SizedBox(height: 16),
        _buildStyledText(useLocalizedStrings()
            .accountDeactivatedPageMessagePart3(contactNumberUrl)),
        const SizedBox(height: 16),
        _buildStyledText(
            useLocalizedStrings().accountDeactivatedPageMessageClosePart1),
        _buildStyledText(useLocalizedStrings()
            .accountDeactivatedPageMessageClosePart2(Configuration.appName)),
        const SizedBox(height: 22),
      ],
    );

Widget _buildStyledText(String text) =>
    Text(text, style: TextStyles.darkBodyBody2RegularHigh);
