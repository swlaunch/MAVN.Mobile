import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/sliver_tab_layout.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/wallet_sliver_tab_layout.dart';

import 'bought_vouchers_list_widget.dart';

class VoucherWalletPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

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
        buildWidget: () => TransactionHistoryWidget(),
      ),

      //TODO uncomment once we add Dashboard
//      SliverTabConfiguration(
//        title: localizedStrings.dashboard,
//        globalKey: GlobalKey(),
//        tabKey: const Key('dashboardTab'),
//        buildWidget: () => const ComingSoonPage(),
//      ),
    ];
    return HomeSliverTabLayout(
      title: localizedStrings.walletPageTitle,
      tabs: tabs,
    );
  }
}
