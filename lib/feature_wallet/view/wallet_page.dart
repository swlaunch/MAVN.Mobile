import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/pending_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_view.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/wallet_actions_widget.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/wallet_balance_section.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/wallet_disabled_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/disabled_overlay.dart';

class WalletPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();

    final themeBloc = useThemeBloc();
    final themeState = useBlocState(themeBloc);

    final balanceBloc = useBalanceBloc();
    final balanceState = useBlocState<BalanceState>(balanceBloc);

    final walletBloc = useWalletBloc();
    final walletState = useBlocState<WalletState>(walletBloc);

    final partnerPaymentsPendingBloc = usePendingPartnerPaymentsBloc();
    final partnerPaymentsPendingState =
        useBlocState<GenericListState>(partnerPaymentsPendingBloc);

    final transactionHistoryBloc = useTransactionHistoryBloc();
    final transactionHistoryState =
        useBlocState<TransactionHistoryState>(transactionHistoryBloc);

    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    void loadData() {
      partnerPaymentsPendingBloc.updateGenericList();
      transactionHistoryBloc.loadTransactionHistory(reset: true);
    }

    useBlocEventListener(balanceBloc, (event) {
      if (event is BalanceUpdatedEvent) {
        loadData();
      }
    });

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.walletPageIndex) {
        throttler.throttle(loadData);
      }
    });

    final walletIsDisabled = balanceState is BalanceLoadedState &&
        (balanceState.isWalletDisabled ?? false);

    final isNetworkError = [
      balanceState,
      transactionHistoryState,
      partnerPaymentsPendingState,
    ].any((state) => state is BaseNetworkErrorState);

    if (themeState is! ThemeSelectedState) {
      return Container();
    }

    final theme = (themeState as ThemeSelectedState).theme;
    return Scaffold(
      backgroundColor: theme.appBackground,
      appBar: AppBar(
        title: Text(
          useLocalizedStrings().walletPageTitle,
          style: TextStyles.h1PageHeader,
        ),
        backgroundColor: theme.appBarBackground,
        elevation: 0,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (transactionHistoryBloc.currentState is TransactionHistoryLoaded &&
              scrollNotification is ScrollUpdateNotification &&
              scrollNotification.metrics.maxScrollExtent ==
                  scrollNotification.metrics.pixels) {
            transactionHistoryBloc.loadTransactionHistory();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildContent(
                  theme,
                  isNetworkError,
                  loadData,
                  transactionHistoryBloc,
                  walletIsDisabled,
                  balanceBloc,
                  router,
                  balanceState,
                  partnerPaymentsPendingState,
                  walletState,
                  tokenSymbol.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BaseAppTheme theme,
    bool isNetworkError,
    VoidCallback loadData,
    TransactionHistoryBloc transactionHistoryBloc,
    bool walletIsDisabled,
    BalanceBloc balanceBloc,
    Router router,
    BalanceState balanceState,
    GenericListState partnerPaymentsPendingState,
    WalletState walletState,
    String tokenSymbol,
  ) =>
      isNetworkError
          ? _buildNetworkError(onRetryTap: loadData)
          : _buildLoadedContent(
              theme,
              transactionHistoryBloc,
              walletIsDisabled,
              loadData,
              balanceBloc,
              router,
              balanceState,
              partnerPaymentsPendingState,
              walletState,
              tokenSymbol,
            );

  Widget _buildLoadedContent(
    BaseAppTheme theme,
    TransactionHistoryBloc transactionHistoryBloc,
    bool walletIsDisabled,
    VoidCallback loadData,
    BalanceBloc balanceBloc,
    Router router,
    BalanceState balanceState,
    GenericListState partnerPaymentsPendingState,
    WalletState walletState,
    String tokenSymbol,
  ) =>
      Column(
        children: [
          if (walletIsDisabled)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
              child: WalletDisabledWidget(),
            ),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  WalletBalanceSection(
                    loadData: () {
                      loadData();
                      balanceBloc.retry();
                    },
                    theme: theme,
                  ),
                  WalletActionsWidget(
                    theme: theme,
                    router: router,
                    partnerPaymentsPendingState: partnerPaymentsPendingState,
                  ),
                  TransactionHistoryView(theme: theme),
                ],
              ),
              if (walletIsDisabled)
                const DisabledOverlay(
                  key: Key('walletDisabledOverlay'),
                )
            ],
          ),
        ],
      );

  Widget _buildNetworkError({VoidCallback onRetryTap}) => Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorWidget(onRetry: onRetryTap),
      );
}
