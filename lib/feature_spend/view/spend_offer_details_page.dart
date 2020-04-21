import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/gradient_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/redeem_transfer_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_spend/ui_components/voucher_out_of_stock_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/disabled_overlay.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/partner_info_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

class SpendOfferDetailsPage extends HookWidget {
  const SpendOfferDetailsPage({@required this.spendRule});

  final SpendRule spendRule;

  @override
  Widget build(BuildContext context) {
    final analyticsManager = useRedeemTransferAnalyticsManager();
    final spendRuleDetailBloc = useSpendRuleDetailBloc();
    final spendRuleDetailBlocState = useBlocState(spendRuleDetailBloc);
    final balanceBloc = useBalanceBloc();
    final balanceState = useBlocState(balanceBloc);
    final voucherPurchaseBloc = useVoucherPurchaseBloc();
    final voucherPurchaseState = useBlocState(voucherPurchaseBloc);
    final baseCurrency =
        useLocalSettingsRepository().getMobileSettings().baseCurrency ?? '';

    final router = useRouter();

    void loadSpendRuleDetail() {
      spendRuleDetailBloc.loadSpendRule(spendRule.id);
    }

    void purchaseVoucher() {
      voucherPurchaseBloc.purchaseVoucher(spendRuleId: spendRule.id);
      analyticsManager.transferToken(businessVertical: OfferVertical.retail);
    }

    useEffect(() {
      loadSpendRuleDetail();
    }, [
      spendRuleDetailBloc,
    ]);

    useBlocEventListener(voucherPurchaseBloc, (event) {
      if (event is VoucherPurchaseSuccessEvent) {
        router.pushVoucherRedemptionSuccessPage(voucherCode: event.voucherCode);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GradientStyles.bronzeGradient),
                child: FlexibleSpaceBar(
                    background: NetworkImageWithPlaceholder(
                  imageUrl: spendRule.imageUrl,
                  height: 200 + MediaQuery.of(context).padding.top,
                  borderRadiusSize: 0,
                ))),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                if (_isVoucherOfferAndOutOfStock(spendRuleDetailBlocState))
                  VoucherOutOfStockWidget(router).build(context),
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        if (spendRuleDetailBlocState
                            is SpendRuleDetailLoadingState)
                          Container(
                              padding: const EdgeInsets.all(24),
                              alignment: Alignment.center,
                              child: const Spinner(
                                  key: Key('offerDetailSpinner'))),
                        if (spendRuleDetailBlocState
                            is SpendRuleDetailNetworkErrorState)
                          Padding(
                              padding: const EdgeInsets.all(16),
                              child: NetworkErrorWidget(
                                  onRetry: loadSpendRuleDetail)),
                        if (spendRuleDetailBlocState
                            is SpendRuleDetailGenericErrorState)
                          _buildGenericError(onRetry: loadSpendRuleDetail),
                        if (spendRuleDetailBlocState
                            is SpendRuleDetailLoadedState)
                          _buildBody(
                            spendRuleDetailBlocState,
                            router,
                            balanceState,
                            purchaseVoucher,
                            voucherPurchaseState,
                            baseCurrency,
                          ),
                      ],
                    ),
                    if (_isVoucherOfferAndOutOfStock(spendRuleDetailBlocState))
                      const DisabledOverlay(
                        key: Key('voucherOutOfStockOverlay'),
                      )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    SpendRuleDetailLoadedState spendRuleDetailState,
    Router router,
    BalanceState balanceState,
    VoidCallback onVoucherPurchaseButtonTapped,
    VoucherPurchaseState voucherPurchaseState,
    String baseCurrency,
  ) =>
      Padding(
        key: const Key('offerDetailView'),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeading(
              spendRuleDetailState: spendRuleDetailState,
              router: router,
            ),
            if (spendRule.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  spendRule.description,
                  style: TextStyles.darkBodyBody1RegularHigh,
                ),
              ),
            if (spendRule.type == OfferVertical.retail)
              _buildVoucherSection(
                spendRuleDetailState,
                balanceState,
                onVoucherPurchaseButtonTapped,
                voucherPurchaseState,
                baseCurrency,
              ),
          ],
        ),
      );

  Widget _buildVoucherSection(
    SpendRuleDetailLoadedState spendRuleDetailState,
    BalanceState balanceState,
    VoidCallback onVoucherPurchaseButtonTapped,
    VoucherPurchaseState voucherPurchaseState,
    String baseCurrency,
  ) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: Text(
            useLocalizedStrings().voucherDetailsAmount.toUpperCase(),
            style: TextStyles.darkInputLabelBold,
          ),
        ),
        const SizedBox(height: 4),
        if (spendRuleDetailState.spendRule?.priceInToken != null)
          TokenAmountWithIcon(
            spendRuleDetailState.spendRule.priceInToken.value,
          ),
        const SizedBox(height: 4),
        if (spendRuleDetailState.spendRule?.price != null)
          Text(
            '${NumberFormatter.toFormattedStringFromDouble(
              spendRuleDetailState.spendRule.price,
            )} $baseCurrency',
            style: TextStyles.darkBodyBody3Regular,
          ),
        const SizedBox(height: 24),
        StandardDivider(),
        const SizedBox(height: 24),
        Text(
          useLocalizedStrings().voucherDetailsAvailableBalance.toUpperCase(),
          style: TextStyles.darkInputLabelBold,
        ),
        const SizedBox(height: 4),
        if (balanceState is BalanceLoadedState) ...[
          TokenAmountWithIcon(balanceState.wallet.balance.value),
          const SizedBox(height: 4),
          Row(children: <Widget>[
            TokenAmountWithIcon(
              balanceState.wallet.stakedBalance?.value ?? '0',
              textStyle: TextStyles.darkBodyBody3Regular,
            ),
            const SizedBox(width: 2),
            Text(
              useLocalizedStrings().tokensLocked,
              style: TextStyles.darkBodyBody3Regular,
            ),
          ]),
          const SizedBox(height: 24),
        ],
        if (voucherPurchaseState is VoucherPurchaseErrorState)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              voucherPurchaseState.error.localize(useContext()),
              style: TextStyles.errorTextBold,
            ),
          ),
        _buildVoucherButton(
          spendRuleDetailState,
          balanceState,
          onVoucherPurchaseButtonTapped,
          voucherPurchaseState,
        ),
      ]);

  Widget _buildVoucherButton(
    SpendRuleDetailLoadedState spendRuleDetailState,
    BalanceState balanceState,
    VoidCallback buyVoucher,
    VoucherPurchaseState voucherPurchaseState,
  ) {
    if (balanceState is BalanceLoadedState &&
        (spendRuleDetailState?.spendRule?.amountInTokens?.decimalValue ??
                Decimal.zero) <=
            (balanceState?.wallet?.balance?.decimalValue ?? Decimal.zero)) {
      return PrimaryButton(
        text: useLocalizedStrings().redeemVoucherButton,
        onTap: buyVoucher,
        isLoading: voucherPurchaseState is VoucherPurchaseInProgressState,
      );
    }
    return Container(
      decoration: BoxDecoration(
          color: ColorStyles.charcoalGrey,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          useLocalizedStrings().redeemVoucherInsufficientFunds,
          style: TextStyles.lightInputTextRegular,
        ),
      ),
    );
  }

  Widget _buildHeading({
    SpendRuleDetailLoadedState spendRuleDetailState,
    Router router,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (spendRule.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                spendRule.title,
                style: TextStyles.darkHeadersH2,
              ),
            ),
          if (spendRuleDetailState.spendRule != null &&
              !ListUtils.isNullOrEmpty(spendRuleDetailState.spendRule.partners))
            PartnerInfoWidget(
                onTap: () => router.pushPartnerListPage(
                    spendRuleDetailState.spendRule.partners),
                partners: spendRuleDetailState.spendRule.partners),
          if (spendRule.title != null)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: DividerDecoration(color: ColorStyles.primaryDark),
            )
        ],
      );

  Widget _buildGenericError({VoidCallback onRetry}) => Padding(
        padding: const EdgeInsets.all(16),
        child: GenericErrorIconWidget(
          errorKey: const Key('genericError'),
          title: useLocalizedStrings().somethingIsNotRightError,
          text: useLocalizedStrings().offerDetailGenericError,
          icon: SvgAssets.genericError,
          onRetryTap: onRetry,
        ),
      );

  bool _isVoucherOfferAndOutOfStock(
    SpendRuleDetailState spendRuleDetailState,
  ) {
    if (spendRuleDetailState is! SpendRuleDetailLoadedState) {
      return false;
    }

    final spendRuleDetail =
        (spendRuleDetailState as SpendRuleDetailLoadedState).spendRule;

    return (spendRuleDetail?.stockCount ?? 0) == 0 &&
        spendRuleDetail?.type == OfferVertical.retail;
  }
}
