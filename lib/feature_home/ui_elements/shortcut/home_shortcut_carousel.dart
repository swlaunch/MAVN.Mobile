import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/app_referral_shortcut.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/wallet_balance_shortcut.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/your_offers_shortcut.dart';
import 'package:lykke_mobile_mavn/library_ui_components/carousel/carousel.dart';

class HomeShortcutCarouselWidget extends HookWidget {
  const HomeShortcutCarouselWidget({@required this.earnRuleListState});

  final GenericListState earnRuleListState;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Carousel(
          children: [
            WalletBalanceShortcutWidget(),
            AppReferralShortcutWidget(earnRuleListState: earnRuleListState),
            YourOffersShortcutWidget(),
          ],
        ),
      );
}
