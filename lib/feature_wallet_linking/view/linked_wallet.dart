import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/ui_components/wallet_balance_box.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_user_verification/bloc/user_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/transaction_button.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/scaled_down_svg.dart';
import 'package:pedantic/pedantic.dart';

class LinkedWalletPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();

    final walletBloc = useWalletBloc();
    final walletState = useBlocState<WalletState>(walletBloc);

    final balance = (walletState is WalletLoadedState)
        ? walletState.wallet.externalBalance?.value
        : null;

    final balanceInBaseCurrency = (walletState is WalletLoadedState)
        ? walletState.externalBalanceInBaseCurrency
        : null;

    final baseCurrencyCode = (walletState is WalletLoadedState)
        ? walletState.baseCurrencyCode
        : null;

    final userVerificationBloc = useUserVerificationBloc();

    if (themeBlocState is! ThemeSelectedState) {
      return Container();
    }
    final theme = (themeBlocState as ThemeSelectedState).theme;
    return ScaffoldWithAppBar(
      useDarkTheme: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              children: <Widget>[
                Heading(useLocalizedStrings().linkedWalletHeader),
                const SizedBox(height: 24),
                WalletBalanceBox(
                  title: useLocalizedStrings().balanceBoxHeader,
                  isLoading: walletState is WalletLoadingState,
                  balance: balance,
                  balanceInBaseCurrency: balanceInBaseCurrency,
                  baseCurrencyCode: baseCurrencyCode,
                  tokenSymbol: tokenSymbol.value,
                  theme: theme,
                )
              ],
            ),
          ),
          Container(
            color: ColorStyles.offWhite,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TransactionButton.simple(
                  valueKey: const Key('sendToExternalWalletButton'),
                  title: useLocalizedStrings().sendToExternalWalletButton,
                  description: useLocalizedStrings()
                      .sendToExternalWalletButtonSubtitle(tokenSymbol.value),
                  iconBackgroundColor: ColorStyles.pale,
                  icon: const ScaledDownSvg(
                    asset: SvgAssets.sendTokensIcon,
                    color: ColorStyles.primaryDark,
                  ),
                  onTap: router.pushLinkedWalletSendPage,
                ),
                const SizedBox(height: 24),
                TransactionButton.simple(
                  valueKey: const Key('receiveExternalWalletButton'),
                  title: useLocalizedStrings().receiveExternalWalletButton,
                  description: useLocalizedStrings()
                      .receiveExternalWalletButtonSubtitle(tokenSymbol.value),
                  iconBackgroundColor: ColorStyles.accentSeaGreen,
                  icon: const ScaledDownSvg(
                    asset: SvgAssets.receiveTokenIcon,
                    color: ColorStyles.primaryDark,
                  ),
                  onTap: router.pushLinkWalletReceivePage,
                ),
                const SizedBox(height: 24),
                TransactionButton.simple(
                  valueKey: const Key('unlinkExternalWalletButton'),
                  title: useLocalizedStrings().unlinkExternalWalletButton,
                  description:
                      useLocalizedStrings().unlinkExternalWalletButtonSubtitle,
                  iconBackgroundColor: ColorStyles.primaryDark,
                  icon: const ScaledDownSvg(
                    asset: SvgAssets.linkingIcon,
                    color: ColorStyles.white,
                  ),
                  onTap: () async {
                    await userVerificationBloc.verify(
                      onSuccess: () =>
                          unawaited(router.pushUnlinkWalletInProgressPage()),
                      onCouldNotVerify: () =>
                          unawaited(router.pushUnlinkWalletInProgressPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
