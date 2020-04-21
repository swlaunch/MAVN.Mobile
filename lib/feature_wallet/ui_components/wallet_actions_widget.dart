import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/circular_button.dart';

class WalletActionsWidget extends HookWidget {
  const WalletActionsWidget({
    @required this.theme,
    @required this.router,
    @required this.partnerPaymentsPendingState,
  });

  final BaseAppTheme theme;
  final Router router;
  final GenericListState partnerPaymentsPendingState;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: ColorStyles.offWhite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularButton(
              key: const Key('goToSendButton'),
              asset: SvgAssets.arrowUp,
              onTap: router.pushTransactionFormPage,
              theme: theme,
              text: useLocalizedStrings().transfer,
            ),
            const SizedBox(width: 24),
            CircularButton(
              key: const Key('goToReceiveButton'),
              asset: SvgAssets.arrowDown,
              onTap: router.pushP2PReceiveTokenPage,
              theme: theme,
              text: useLocalizedStrings().receive,
            ),
            const SizedBox(width: 24),
            CircularButton(
              key: const Key('paymentRequestsButton'),
              asset: SvgAssets.transferRequestIcon,
              onTap: router.pushPaymentRequestListPage,
              theme: theme,
              text: useLocalizedStrings().requests,
              hasBadge: partnerPaymentsPendingState is GenericListLoadedState &&
                  (partnerPaymentsPendingState as GenericListLoadedState)
                          .totalCount >
                      0,
            ),
          ],
        ),
      );
}
