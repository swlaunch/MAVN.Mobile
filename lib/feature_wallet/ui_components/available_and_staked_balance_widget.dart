import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/scaled_down_svg.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_icon.dart';

class AvailableAndStakedBalanceWidget extends StatelessWidget {
  const AvailableAndStakedBalanceWidget({
    @required this.wallet,
    this.isLoading = false,
  });

  AvailableAndStakedBalanceWidget.withState(WalletState state)
      : wallet = state is WalletLoadedState ? state.wallet : null,
        isLoading = state is WalletLoadingState;

  final WalletResponseModel wallet;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => isLoading || wallet == null
      ? Container(
          height: 92,
          child: const Align(
            child: Spinner(),
            alignment: Alignment.center,
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                LocalizedStrings.of(context)
                    .propertyPaymentAvailableBalanceLabel
                    .toUpperCase(),
                style: TextStyles.darkInputLabelBold),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const TokenIcon(),
                const SizedBox(width: 4),
                Text(
                  wallet.balance.displayValueWithoutTrailingZeroes,
                  style: TextStyles.darkBodyBody1Bold,
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (wallet?.stakedBalance?.value != null)
              Row(
                children: <Widget>[
                  const SizedBox(width: 2),
                  const ScaledDownSvg(
                    asset: SvgAssets.tokenLight,
                    color: ColorStyles.primaryDark,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    LocalizedStrings.of(context).transactionFormStakedAmount(
                        wallet.stakedBalance.displayValueWithoutTrailingZeroes),
                    style: TextStyles.darkBodyBody4Regular,
                  ),
                ],
              ),
            const SizedBox(height: 24),
            StandardDivider(),
          ],
        );
}
