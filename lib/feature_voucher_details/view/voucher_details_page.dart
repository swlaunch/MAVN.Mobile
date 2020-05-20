import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_details_bloc_state.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/bloc/campaign_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_about_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_top_section.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/voucher_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/view/voucher_qr_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/voucher_card_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/view/bought_vouchers_list_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/styled_outline_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_sliver_hero.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class VoucherDetailsPage extends HookWidget {
  const VoucherDetailsPage({@required this.voucher, this.voucherColor});

  final VoucherResponseModel voucher;
  final Color voucherColor;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final localizedStrings = useLocalizedStrings();

    final campaignDetailsBloc = useCampaignDetailsBloc();
    final campaignDetailsBlocState = useBlocState(campaignDetailsBloc);

    final voucherDetailsBloc = useVoucherDetailsBloc();
    final voucherDetailsBlocState = useBlocState(voucherDetailsBloc);

    void loadData() {
      campaignDetailsBloc.getDetails(identifier: voucher.campaignId);
      voucherDetailsBloc.getDetails(identifier: voucher.shortCode);
    }

    useEffect(() {
      loadData();
    }, [campaignDetailsBloc, voucherDetailsBloc]);

    void onSendToFriendTap() {
      router.pushComingSoonPage(
        title: localizedStrings.sendToFriend,
        hasBackButton: true,
      );
    }

    void onCancelTap() {
      //TODO reload the list once you get a response from BE
      router.pushComingSoonPage(
        title: localizedStrings.cancelVoucher,
        hasBackButton: true,
      );
    }

    void onBuyTap() {
      router.pushComingSoonPage(
        title: localizedStrings.redeemOffer,
        hasBackButton: true,
      );
    }

    final isLoading = [campaignDetailsBlocState, voucherDetailsBlocState]
        .any((element) => element is GenericDetailsLoadingState);

    final isNetworkError = [campaignDetailsBlocState, voucherDetailsBlocState]
        .any((element) => element is GenericDetailsNetworkErrorState);

    return ScaffoldWithSliverHero(
      title: localizedStrings.viewVoucher,
      heroTag: '${BoughtVouchersList.voucherHeroTag}${voucher.id}',
      heroWidget: Material(
        type: MaterialType.transparency,
        child: VoucherCardWidget(
          imageUrl: voucher.imageUrl,
          color: voucherColor,
          partnerName: voucher.partnerName,
          voucherName: voucher.campaignName,
          expirationDate: voucher.expirationDate,
          voucherStatus: voucher.status,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: VoucherCardWidget.cardHeight / 2),
                if (voucherDetailsBlocState is GenericDetailsLoadedState)
                  _buildVoucherLoadedState(voucherDetailsBlocState.details),
                if (campaignDetailsBlocState is GenericDetailsLoadedState)
                  ..._buildCampaignLoadedState(
                      campaignDetailsBlocState.details),
              ],
            ),
          ),
          if (voucherDetailsBlocState is GenericDetailsLoadedState)
            _buildButtonBar(
              voucherDetails: voucherDetailsBlocState.details,
              localizedStrings: localizedStrings,
              onSendToFriendTap: onSendToFriendTap,
              onCancelTap: onCancelTap,
              onBuyTap: onBuyTap,
            ),
          if (isLoading) const Center(child: Spinner()),
          if (isNetworkError)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: NetworkErrorWidget(
                  onRetry: loadData,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _voucherIsExpired() =>
      voucher.expirationDate != null &&
      DateTime.now().isAfter(voucher.expirationDate);

  Widget _buildVoucherLoadedState(VoucherDetailsResponseModel voucherDetails) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (voucherDetails.voucher.status == VoucherStatus.sold &&
              !_voucherIsExpired())
            VoucherQRWidget(
              voucherCode: voucherDetails.validationCode,
            ),
        ],
      );

  List<Widget> _buildCampaignLoadedState(CampaignResponseModel campaign) => [
        const SizedBox(height: 16),
        VoucherTopSection(partner: campaign.partnerName),
        const SizedBox(height: 32),
        CampaignAboutSection(about: campaign.description),
      ];

  Widget _buildButtonBar({
    VoucherDetailsResponseModel voucherDetails,
    LocalizedStrings localizedStrings,
    VoidCallback onSendToFriendTap,
    VoidCallback onCancelTap,
    VoidCallback onBuyTap,
  }) {
    ///if voucher is expired, show no buttons
    if (_voucherIsExpired()) {
      return Container();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: ColorStyles.alabaster,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (voucherDetails.voucher.status == VoucherStatus.sold)
              Expanded(
                child: PrimaryButton(
                  text: localizedStrings.sendToFriend,
                  onTap: onSendToFriendTap,
                ),
              ),
            if (voucherDetails.voucher.status == VoucherStatus.reserved) ...[
              Flexible(
                child: StyledOutlineButton(
                  useDarkTheme: true,
                  text: localizedStrings.cancelVoucher,
                  onTap: onCancelTap,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: PrimaryButton(
                  text: localizedStrings.redeemOffer,
                  onTap: onBuyTap,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
