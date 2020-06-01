import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_about_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_top_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/ui_components/campaign_widget.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/view/campaign_list_page.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/bottom_primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_sliver_hero.dart';

class CampaignDetailsPage extends HookWidget {
  const CampaignDetailsPage({@required this.campaign});

  final CampaignResponseModel campaign;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

    final externalRouter = useExternalRouter();

    final voucherPurchaseBloc = useVoucherPurchaseBloc();
    final voucherPurchaseState = useBlocState(voucherPurchaseBloc);

    useBlocEventListener(voucherPurchaseBloc, (event) {
      if (event is VoucherPurchaseSuccessEvent) {
        externalRouter.launchWebsite(event.paymentUrl);
      }
    });

    void reserveVoucher() {
      voucherPurchaseBloc.purchaseVoucher(campaignId: campaign.id);
    }

    return ScaffoldWithSliverHero(
      title: localizedStrings.viewOffer,
      heroTag: '${CampaignListPage.campaignHeroTag}${campaign.id}',
      heroWidget: CampaignWidget(
        title: campaign.name,
        price: campaign.price,
        imageUrl: campaign.imageUrl,
      ),
      bottom: BottomPrimaryButton(
        text: localizedStrings.redeemOffer,
        isLoading: voucherPurchaseState is VoucherPurchaseLoadingState,
        onTap: reserveVoucher,
      ),
      error: _getErrorFromState(
        context: context,
        voucherPurchaseState: voucherPurchaseState,
        onRetryTap: reserveVoucher,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: CampaignWidget.cardHeight / 4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              VoucherTopSection(partner: campaign.partnerName),
              const SizedBox(height: 32),
              CampaignAboutSection(about: campaign.description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getErrorFromState({
    BuildContext context,
    VoucherPurchaseState voucherPurchaseState,
    VoidCallback onRetryTap,
  }) {
    if (voucherPurchaseState is VoucherPurchaseNetworkErrorState) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorWidget(onRetry: onRetryTap),
      );
    }
    if (voucherPurchaseState is VoucherPurchaseErrorState) {
      return GenericErrorWidget(
          onRetryTap: onRetryTap,
          text: voucherPurchaseState.error.localize(context));
    }
    return Container();
  }
}
