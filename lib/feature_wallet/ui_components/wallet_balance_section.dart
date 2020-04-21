import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_balance/ui_components/wallet_balance_box.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';

class WalletBalanceSection extends HookWidget {
  const WalletBalanceSection({@required this.loadData, @required this.theme});

  final VoidCallback loadData;
  final BaseAppTheme theme;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final balanceBloc = useBalanceBloc();
    final balanceState = useBlocState(balanceBloc);

    final balance = (balanceState is BalanceLoadedState)
        ? balanceState.wallet.balance.value
        : null;

    final balanceInBaseCurrency = (balanceState is BalanceLoadedState)
        ? balanceState.conversionRateAmount?.amount
        : null;

    final baseCurrencyCode =
        (balanceState is BalanceLoadedState) ? balanceState.currencyCode : null;

    return balanceState is BalanceErrorState
        ? _buildError(balanceState)
        : Padding(
            padding: const EdgeInsets.all(24),
            child: WalletBalanceBox(
              title: useLocalizedStrings().walletPageMyTotalTokens,
              balance: balance,
              isLoading: balanceState is BalanceLoadingState,
              balanceInBaseCurrency: balanceInBaseCurrency,
              baseCurrencyCode: baseCurrencyCode,
              tokenSymbol: tokenSymbol.value,
              theme: theme,
            ),
          );
  }

  Widget _buildError(BalanceErrorState errorState) => GenericErrorIconWidget(
        errorKey: const Key('walletBalanceSectionKey'),
        title: errorState.errorTitle.localize(useContext()),
        text: errorState.errorSubtitle.localize(useContext()),
        onRetryTap: loadData,
        icon: errorState.iconAsset,
        margin: const EdgeInsets.all(24),
      );
}
