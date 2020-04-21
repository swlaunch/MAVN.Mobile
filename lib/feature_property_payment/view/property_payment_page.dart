import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_balance_error_widget.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/view/property_payment_form.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/available_and_staked_balance_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_icon.dart';

class PropertyPaymentPage extends HookWidget {
  const PropertyPaymentPage(
    this.spendRuleId,
    this.property,
    this.extendedInstalment,
  );

  final String spendRuleId;
  final Property property;
  final ExtendedInstalmentModel extendedInstalment;

  @override
  Widget build(BuildContext context) {
    final walletBloc = useWalletBloc();
    final walletState = useBlocState<WalletState>(walletBloc);

    return DismissKeyboardOnTap(
      child: ScaffoldWithAppBar(
        body: Column(
          children: <Widget>[
            PageTitle(title: useLocalizedStrings().propertyPaymentPageTitle),
            const SizedBox(height: 16),
            _buildContent(
              walletState: walletState,
              onRetryTap: walletBloc.fetchWallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    WalletState walletState,
    VoidCallback onRetryTap,
  }) {
    if (walletState is WalletLoadingState) {
      return const Spinner(
        key: Key('walletLoadingSpinner'),
      );
    }

    if (walletState is WalletLoadedState) {
      return Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildPageDetails(),
                const SizedBox(height: 36),
                ..._buildPropertyDetails(),
                _buildDivider(),
                ..._buildInstalmentDetails(),
                _buildDivider(),
                _buildAvailableBalanceWidget(walletState),
                const SizedBox(height: 16),
                PropertyPaymentForm(
                  balance: walletState.wallet.balance,
                  spendRuleId: spendRuleId,
                  extendedInstalment: extendedInstalment,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (walletState is WalletErrorState) {
      return TransactionBalanceErrorWidget(
        onRetryTap: onRetryTap,
      );
    }

    return Container();
  }

  Widget _buildPageDetails() => Text(
        useLocalizedStrings().propertyPaymentPageSubDetails,
        style: TextStyles.darkBodyBody1RegularHigh,
      );

  List<Widget> _buildPropertyDetails() => [
        ..._buildItemDetailsLabel(
            useLocalizedStrings().propertyPaymentProperty),
        Text(
          property.name,
          style: TextStyles.darkBodyBody1Bold,
        )
      ];

  List<Widget> _buildInstalmentDetails() {
    final amountInTokens = extendedInstalment
        .instalment.amountInTokens.displayValueWithoutTrailingZeroes;
    final totalInFiat = extendedInstalment
        .instalment.amountInFiat.withoutTrailingZeroesWithAsset;
    return [
      ..._buildItemDetailsLabel(extendedInstalment.instalment.name),
      Row(
        children: <Widget>[
          const TokenIcon(),
          const SizedBox(width: 4),
          Text(
            '$amountInTokens ($totalInFiat)',
            style: TextStyles.darkBodyBody1Bold,
          ),
        ],
      ),
      const SizedBox(height: 4),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody4Regular,
          children: [
            TextSpan(text: extendedInstalment.formattedDate),
            if (extendedInstalment.isOverdue) ..._buildOverdueText(),
          ],
        ),
      )
    ];
  }

  List<TextSpan> _buildOverdueText() => [
        const TextSpan(text: ' • '),
        TextSpan(
          text: useLocalizedStrings().installmentOverdue,
          style: TextStyles.bodyBody4RegularError,
        ),
      ];

  Widget _buildAvailableBalanceWidget(WalletState walletState) =>
      AvailableAndStakedBalanceWidget.withState(walletState);

  List<Widget> _buildItemDetailsLabel(String text) => [
        Text(
          text.toUpperCase(),
          style: TextStyles.darkInputLabelBold,
        ),
        const SizedBox(height: 4),
      ];

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        child: StandardDivider(),
      );
}
