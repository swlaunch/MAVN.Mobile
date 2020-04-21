import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_welcome/analytics/welcome_analytics_manager.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/styled_outline_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';

class WelcomePage extends HookWidget with DynamicLinkManagerMixin {
  @override
  Widget build(BuildContext context) {
    startListenOnceForDynamicLinks();
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();
    final analyticsManager = useWelcomeAnalyticsManager();

    void onCreateAccountButtonTapped() {
      analyticsManager.createAccountTap();
      router.pushRegisterPage();
    }

    void onSignInButtonTapped() {
      analyticsManager.signInTap();
      router.pushLoginPage();
    }

    return AuthScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 56),
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Image.asset(
                ImageAssets.welcomePageImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            useLocalizedStrings().welcomePageHeader(Configuration.appName),
            style: TextStyles.darkHeadersH2,
          ),
          Text(
            useLocalizedStrings().welcomePageSubHeader(tokenSymbol.value),
            style: TextStyles.darkBodyBody3RegularHigh,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: StyledOutlineButton(
              key: const Key('welcomeSignInButton'),
              text: useLocalizedStrings().welcomeSignInButtonText,
              onTap: onSignInButtonTapped,
              useDarkTheme: true,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PrimaryButton(
                buttonKey: const Key('welcomeCreateAccountButton'),
                text: useLocalizedStrings().welcomeCreateAccountButtonText,
                onTap: onCreateAccountButtonTapped,
                isLight: false),
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
