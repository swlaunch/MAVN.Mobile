import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/home_shortcut_item.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class WalletBalanceShortcutWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final balanceBloc = useBalanceBloc();
    final balanceBlocState = useBlocState(balanceBloc);

    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);

    if (themeBlocState is ThemeUninitializedState) {
      return Container();
    }
    if (themeBlocState is ThemeSelectedState) {
      final theme = themeBlocState.theme;
      return HomeShortcutItemWidget(
        backgroundColor: theme.homeWalletBackground,
        text: useLocalizedStrings().walletPageTitle,
        onTap: router.switchToWalletTab,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (balanceBlocState is BalanceLoadedState)
                ..._buildBalanceText(context, tokenSymbol.value,
                    balanceBlocState.wallet.balance.value),
              if (balanceBlocState is BaseLoadingState) const Spinner()
            ],
          ),
        ),
      );
    }
  }

  List<Widget> _buildBalanceText(
          BuildContext context, String tokenSymbol, String balance) =>
      [
        AutoSizeText(
          LocalizedStrings.of(context).balanceBoxHeader.toUpperCase(),
          style: TextStyles.lightBodyBody3Regular,
        ),
        AutoSizeText(
          '$tokenSymbol $balance',
          style: TextStyles.lightHeadersH2,
          maxLines: 1,
        )
      ];
}
