import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';

class MandatoryAppUpgradePage extends HookWidget {
  const MandatoryAppUpgradePage();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 112),
          child: Column(
            children: [
              SvgPicture.asset(
                SvgAssets.token,
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 16),
              Text(
                useLocalizedStrings().mandatoryAppUpgradePageTitle,
                style: TextStyles.h1PageHeader,
              ),
              const SizedBox(height: 12),
              Text(
                useLocalizedStrings().mandatoryAppUpgradePageContent,
                textAlign: TextAlign.center,
                style: TextStyles.darkBodyBody2Regular,
              ),
              const Spacer(),
              PrimaryButton(
                text: useLocalizedStrings().mandatoryAppUpgradePageButton,
                onTap: router.redirectToAppStores,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
