import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_details_bloc_state.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/ui_components/campaign_about_section.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/bloc/invalidate_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/bloc/invalidate_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/voucher_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/voucher_card_widget.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/view/bought_vouchers_list_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_sliver_hero.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class SmeInvalidateVoucherPage extends HookWidget {
  const SmeInvalidateVoucherPage({@required this.voucherShortCode});

  final String voucherShortCode;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final localizedStrings = useLocalizedStrings();

    final voucherDetailsBloc = useVoucherDetailsBloc();
    final voucherDetailsBlocState = useBlocState(voucherDetailsBloc);

    final invalidateVoucherBloc = useInvalidateVoucherBloc();
    final invalidateVoucherState = useBlocState(invalidateVoucherBloc);

    useBlocEventListener(invalidateVoucherBloc, (event) {
      if (event is InvalidateVoucherSuccessEvent) {
        router.replaceWithSmeInvalidateSuccessPage();
      }
    });

    void loadData() {
      voucherDetailsBloc.getDetails(identifier: voucherShortCode);
    }

    void invalidateVoucher() {
      if (voucherDetailsBlocState is GenericDetailsLoadedState) {
        final VoucherDetailsResponseModel voucherDetails =
            voucherDetailsBlocState.details;
        invalidateVoucherBloc.invalidateVoucher(
          voucherShortCode: voucherDetails.voucher.shortCode,
          voucherValidationCode: voucherDetails.validationCode,
        );
      }
    }

    useEffect(() {
      loadData();
    }, [voucherDetailsBloc]);

    if (voucherDetailsBlocState is! GenericDetailsLoadedState) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              if (voucherDetailsBlocState is BaseLoadingState)
                Expanded(
                    child: Container(child: const Center(child: Spinner()))),
              if (voucherDetailsBlocState is BaseNetworkErrorState)
                _buildNetworkError(loadData),
              if (voucherDetailsBlocState is GenericDetailsErrorState)
                _buildGenericError(
                  onRetryTap: loadData,
                  text: localizedStrings.somethingIsNotRightError,
                )
            ],
          ),
        ),
      );
    }

    if (voucherDetailsBlocState is GenericDetailsLoadedState) {
      final voucherDetails =
          voucherDetailsBlocState.details as VoucherDetailsResponseModel;
      return ScaffoldWithSliverHero(
        title: localizedStrings.viewVoucher,
        heroTag:
            '${BoughtVouchersList.voucherHeroTag}${voucherDetails.voucher.id}',
        heroWidget: Material(
          type: MaterialType.transparency,
          child: VoucherCardWidget(
            imageUrl: voucherDetails.voucher.imageUrl,
            partnerName: voucherDetails.voucher.partnerName,
            voucherName: voucherDetails.voucher.campaignName,
            expirationDate: voucherDetails.voucher.expirationDate,
            purchaseDate: voucherDetails.voucher.purchaseDate,
            voucherStatus: voucherDetails.voucher.status,
            price: voucherDetails.voucher.price,
          ),
        ),
        bottom: _buildInvalidateButton(
          voucherDetails: voucherDetailsBlocState.details,
          localizedStrings: localizedStrings,
          onInvalidateTap: invalidateVoucher,
          isInvalidateLoading: invalidateVoucherState is BaseLoadingState,
        ),
        error: _getErrorFromState(
          localizedStrings: localizedStrings,
          context: context,
          invalidateVoucherBlocState: invalidateVoucherState,
          onInvalidateRetry: invalidateVoucher,
        ),
        body: Padding(
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
      );
    }
  }

  bool _voucherIsExpired(VoucherResponseModel voucher) =>
      voucher.expirationDate != null &&
      DateTime.now().isAfter(voucher.expirationDate);

  List<Widget> _buildVoucherLoadedState(
          VoucherDetailsResponseModel voucherDetails) =>
      [
        const SizedBox(height: 32),
        CampaignAboutSection(about: voucherDetails.voucher.description),
      ];

  Widget _buildInvalidateButton({
    VoucherDetailsResponseModel voucherDetails,
    LocalizedStrings localizedStrings,
    VoidCallback onInvalidateTap,
    bool isInvalidateLoading,
  }) {
    ///if voucher is expired, show no buttons
    if (_voucherIsExpired(voucherDetails.voucher)) {
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
                  text: localizedStrings.invalidateVoucher,
                  onTap: onInvalidateTap,
                  isLoading: isInvalidateLoading,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getErrorFromState({
    @required LocalizedStrings localizedStrings,
    @required BuildContext context,
    @required InvalidateVoucherState invalidateVoucherBlocState,
    @required VoidCallback onInvalidateRetry,
  }) {
    if (invalidateVoucherBlocState is BaseNetworkErrorState) {
      return _buildNetworkError(onInvalidateRetry);
    }
    if (invalidateVoucherBlocState is InvalidateVoucherErrorState) {
      return _buildGenericError(
        onRetryTap: onInvalidateRetry,
        text: invalidateVoucherBlocState.error.localize(context),
      );
    }
  }

  Widget _buildNetworkError(VoidCallback onRetry) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: NetworkErrorWidget(onRetry: onRetry),
      );

  Widget _buildGenericError({VoidCallback onRetryTap, String text}) =>
      GenericErrorWidget(
        onRetryTap: onRetryTap,
        text: text,
      );
}
