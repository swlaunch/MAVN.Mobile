import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_coming_soon/view/coming_soon_page.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_view.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/sliver_tab_layout.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/wallet_sliver_tab_layout.dart';

import 'bought_vouchers_list_widget.dart';

class VoucherWalletPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

    final transactionHistoryBloc = useTransactionHistoryBloc();

    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    void loadData() {
      transactionHistoryBloc.loadTransactionHistory(reset: true);
    }

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.walletPageIndex) {
        throttler.throttle(loadData);
      }
    });

    final tabs = [
      SliverTabConfiguration(
        title: localizedStrings.vouchers,
        globalKey: GlobalKey(),
        tabKey: const Key('vouchersTab'),
        buildWidget: () => BoughtVouchersList(),
      ),
      SliverTabConfiguration(
        title: localizedStrings.transactions,
        globalKey: GlobalKey(),
        tabKey: const Key('transactionsTab'),
        buildWidget: () => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (transactionHistoryBloc.currentState
                    is TransactionHistoryLoaded &&
                scrollNotification is ScrollUpdateNotification &&
                scrollNotification.metrics.maxScrollExtent ==
                    scrollNotification.metrics.pixels) {
              transactionHistoryBloc.loadTransactionHistory();
            }
          },
          child: TransactionHistoryView(),
        ),
      ),
      SliverTabConfiguration(
        title: localizedStrings.dashboard,
        globalKey: GlobalKey(),
        tabKey: const Key('dashboardTab'),
        buildWidget: () => const ComingSoonPage(),
      ),
    ];
    return HomeSliverTabLayout(
      title: localizedStrings.walletPageTitle,
      tabs: tabs,
    );
  }
}
