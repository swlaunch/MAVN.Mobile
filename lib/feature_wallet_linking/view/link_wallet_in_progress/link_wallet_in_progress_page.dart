import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class LinkWalletInProgressPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final walletBloc = useWalletBloc();

    return ScaffoldWithAppBar(
      useDarkTheme: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Heading(useLocalizedStrings().linkWalletInProgressHeader),
            const SizedBox(height: 64),
            Text(useLocalizedStrings().linkWalletInProgressTitle,
                textAlign: TextAlign.center,
                style: TextStyles.darkBodyBody2Regular),
            const SizedBox(height: 54),
            _buildImage(),
            const SizedBox(height: 54),
            Expanded(
              child: Text(useLocalizedStrings().linkWalletInProgressDescription,
                  textAlign: TextAlign.center,
                  style: TextStyles.darkBodyBody3RegularHigh),
            ),
            PrimaryButton(
              text: useLocalizedStrings().backToWalletButton,
              onTap: () {
                walletBloc.fetchWallet();
                router.popToRoot();
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() => SvgPicture.asset(
        SvgAssets.walletLinkingInProgress,
        placeholderBuilder: (context) => Container(
          child: const Center(child: Spinner()),
          height: 120,
          width: 160,
        ),
      );
}
