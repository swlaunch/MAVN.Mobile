import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_details_bloc_state.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_about_section.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_top_section.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/cancel_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/cancel_voucher_bloc_state.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/payment_url_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/payment_url_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/voucher_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/view/voucher_qr_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/voucher_card_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/view/bought_vouchers_list_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/styled_outline_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
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
    final externalRouter = useExternalRouter();
    final localizedStrings = useLocalizedStrings();

    final voucherDetailsBloc = useVoucherDetailsBloc();
    final voucherDetailsBlocState = useBlocState(voucherDetailsBloc);

    final cancelVoucherBloc = useCancelVoucherBloc();
    final cancelVoucherBlocState = useBlocState(cancelVoucherBloc);

    final paymentUrlBloc = usePaymentUrlBloc();
    final paymentUrlBlocState = useBlocState(paymentUrlBloc);

    useBlocEventListener(cancelVoucherBloc, (event) {
      if (event is CancelVoucherSuccessEvent) {
        router.pop();
      }
    });

    useBlocEventListener(paymentUrlBloc, (event) {
      if (event is PaymentUrlSuccessEvent) {
        externalRouter.launchWebsite(event.paymentUrl);
      }
    });

    void loadData() {
      voucherDetailsBloc.getDetails(identifier: voucher.shortCode);
    }

    void cancelVoucher() {
      cancelVoucherBloc.cancelVoucher(shortCode: voucher.shortCode);
    }

    useEffect(() {
      loadData();
    }, [voucherDetailsBloc]);

    void onSendToFriendTap() {
      router.pushTransferVoucherPage(voucherShortCode: voucher.shortCode);
    }

    void getPaymentUrl() {
      paymentUrlBloc.getPaymentUrl(shortCode: voucher.shortCode);
    }

    final isLoading = [
      voucherDetailsBlocState,
      cancelVoucherBlocState,
    ].any((element) => element is BaseLoadingState);

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
          purchaseDate: voucher.purchaseDate,
          voucherStatus: voucher.status,
          price: voucher.price,
        ),
      ),
      bottom: voucherDetailsBlocState is GenericDetailsLoadedState
          ? _buildButtonBar(
              voucherDetails: voucherDetailsBlocState.details,
              localizedStrings: localizedStrings,
              onSendToFriendTap: onSendToFriendTap,
              onCancelTap: cancelVoucher,
              onBuyTap: getPaymentUrl,
              isCancelLoading: cancelVoucherBlocState is BaseLoadingState,
              isPurchaseLoading: paymentUrlBlocState is PaymentUrlLoadingState,
            )
          : Container(),
      error: _getErrorFromState(
        localizedStrings: localizedStrings,
        context: context,
        voucherDetailsBlocState: voucherDetailsBlocState,
        onLoadRetry: loadData,
        cancelVoucherBlocState: cancelVoucherBlocState,
        onCancelRetry: cancelVoucher,
        paymentUrlState: paymentUrlBlocState,
        onGetPaymentUrlRetry: getPaymentUrl,
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
                  ..._buildVoucherLoadedState(voucherDetailsBlocState.details),
              ],
            ),
          ),
          if (isLoading) const Center(child: Spinner()),
        ],
      ),
    );
  }

  Widget _getErrorFromState({
    @required LocalizedStrings localizedStrings,
    @required BuildContext context,
    @required GenericDetailsState voucherDetailsBlocState,
    @required VoidCallback onLoadRetry,
    @required CancelVoucherState cancelVoucherBlocState,
    @required VoidCallback onCancelRetry,
    @required PaymentUrlState paymentUrlState,
    @required VoidCallback onGetPaymentUrlRetry,
  }) {
    if (voucherDetailsBlocState is BaseNetworkErrorState) {
      return _buildNetworkError(onLoadRetry);
    }
    if (voucherDetailsBlocState is GenericDetailsErrorState) {
      return _buildGenericError(
        onRetryTap: onLoadRetry,
        text: localizedStrings.somethingIsNotRightError,
      );
    }
    if (cancelVoucherBlocState is BaseNetworkErrorState) {
      return _buildNetworkError(onCancelRetry);
    }
    if (cancelVoucherBlocState is CancelVoucherErrorState) {
      return _buildGenericError(
        onRetryTap: onCancelRetry,
        text: cancelVoucherBlocState.error.localize(context),
      );
    }
    if (paymentUrlState is BaseNetworkErrorState) {
      return _buildNetworkError(onGetPaymentUrlRetry);
    }
    if (paymentUrlState is PaymentUrlErrorState) {
      return _buildGenericError(
        onRetryTap: onGetPaymentUrlRetry,
        text: paymentUrlState.error.localize(context),
      );
    }
  }

  Widget _buildNetworkError(VoidCallback onRetry) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: NetworkErrorWidget(onRetry: onRetry),
      );

  bool _voucherIsExpired() =>
      voucher.expirationDate != null &&
      DateTime.now().isAfter(voucher.expirationDate);

  List<Widget> _buildVoucherLoadedState(
          VoucherDetailsResponseModel voucherDetails) =>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (voucherDetails.voucher.status == VoucherStatus.sold &&
                !_voucherIsExpired())
              VoucherQRWidget(
                partnerId: voucher.partnerId,
                voucherCode: voucherDetails.voucher.shortCode,
                validationCode: voucherDetails.validationCode,
              ),
          ],
        ),
        const SizedBox(height: 16),
        VoucherTopSection(partner: voucher.partnerName),
        const SizedBox(height: 32),
        CampaignAboutSection(about: voucher.description),
      ];

  Widget _buildButtonBar({
    VoucherDetailsResponseModel voucherDetails,
    LocalizedStrings localizedStrings,
    VoidCallback onSendToFriendTap,
    VoidCallback onCancelTap,
    VoidCallback onBuyTap,
    bool isCancelLoading,
    bool isPurchaseLoading = false,
  }) {
    ///if voucher is expired, show no buttons
    if (_voucherIsExpired()) {
      return Container();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AbsorbPointer(
        absorbing: isCancelLoading || isPurchaseLoading,
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
                    isLoading: isCancelLoading,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: PrimaryButton(
                    text: localizedStrings.redeemOffer,
                    onTap: onBuyTap,
                    isLoading: isPurchaseLoading,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenericError({VoidCallback onRetryTap, String text}) =>
      GenericErrorWidget(
        onRetryTap: onRetryTap,
        text: text,
      );
}
