import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_about_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_top_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/ui_components/campaign_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/scroll_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/bottom_primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';

class CampaignDetailsPage extends HookWidget {
  const CampaignDetailsPage({@required this.campaign});

  static const double _sliverImageSize = 200;

  final CampaignResponseModel campaign;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

    final externalRouter = useExternalRouter();

    final scrollController = useScrollController();

    final voucherPurchaseBloc = useVoucherPurchaseBloc();
    final voucherPurchaseState = useBlocState(voucherPurchaseBloc);

    useBlocEventListener(voucherPurchaseBloc, (event) {
      if (event is VoucherPurchaseSuccessEvent) {
        externalRouter.launchUrl(event.paymentUrl);
      }
    });

    void reserveVoucher() {
      voucherPurchaseBloc.purchaseVoucher(campaignId: campaign.id);
    }

    return Scaffold(
      backgroundColor: ColorStyles.offWhite,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _sliverImageSize,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  color: ColorStyles.geraldine,
                  child: FlexibleSpaceBar(
                    background: Container(
                      color: ColorStyles.geraldine,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      VoucherTopSection(
                        vendor: campaign.partnerName,
                        offerName: campaign.name,
                        expirationDate: campaign.toDate,
                      ),
                      const SizedBox(height: 32),
                      CampaignAboutSection(about: campaign.description),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildVoucherCard(context, scrollController),
          BottomPrimaryButton(
            text: localizedStrings.redeemOffer,
            isLoading: voucherPurchaseState is VoucherPurchaseLoadingState,
            onTap: reserveVoucher,
          ),
          if (voucherPurchaseState is VoucherPurchaseNetworkErrorState)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildNetworkError(onRetryTap: reserveVoucher),
            ),
          if (voucherPurchaseState is VoucherPurchaseErrorState)
            Align(
              alignment: Alignment.bottomCenter,
              child: GenericErrorWidget(
                  onRetryTap: reserveVoucher,
                  text: voucherPurchaseState.error.localize(context)),
            )
        ],
      ),
    );
  }

  Widget _buildVoucherCard(
      BuildContext context, ScrollController scrollController) {
    //starting widget position
    final defaultTopMargin =
        _sliverImageSize + MediaQuery.of(context).padding.top - 150.0;
    //pixels from top where opacity change should start
    final double opacityChangeStart = defaultTopMargin / 2;
    //pixels from top where opacity change should end
    final double opacityChangeEnd = opacityChangeStart / 2;

    double top = defaultTopMargin;
    double opacity = 1;
    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - opacityChangeStart) {
        //offset small => don't decrease opacity
        opacity = 1;
      } else if (offset < defaultTopMargin - opacityChangeEnd) {
        //opacityChangeStart < offset> opacityChangeEnd => decrease opacity
        opacity =
            (defaultTopMargin - opacityChangeEnd - offset) / opacityChangeEnd;
      } else {
        //offset passed opacityChangeEnd => hide widget
        opacity = 0;
      }
    }
    final availableWidth = MediaQuery.of(context).size.width;

    final width = availableWidth - (2 * 24);
    return Positioned(
      top: top + 24,
      left: 24,
      child: Opacity(
        opacity: opacity,
        child: Hero(
          tag: 'voucher_${campaign.id}',
          child: Container(
            width: width,
            child: CampaignWidget(
              title: campaign.name,
              price: campaign.price,
              imageUrl: campaign.getImageUrl(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkError({VoidCallback onRetryTap}) => Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorWidget(onRetry: onRetryTap),
      );
}
