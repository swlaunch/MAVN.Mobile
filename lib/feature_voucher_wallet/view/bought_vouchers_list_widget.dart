import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/voucher_card_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class BoughtVouchersList extends HookWidget {
  final voucherTintColors = [
    ColorStyles.piper,
    ColorStyles.jakarta,
    ColorStyles.blueStone,
    ColorStyles.eminence,
  ];

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final voucherListBloc = useVoucherListBloc();
    final voucherListBlocState = useBlocState(voucherListBloc);

    final data = useState(<VoucherResponseModel>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      voucherListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      voucherListBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [voucherListBloc]);

    if (voucherListBlocState is GenericListLoadedState) {
      data.value = voucherListBlocState.list;
    }
    int tintColorIndex = 0;

    return Stack(
      children: [
        RefreshIndicator(
          color: ColorStyles.gold1,
          onRefresh: () async =>
              voucherListBloc.updateGenericList(refresh: true),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InfiniteListWidget(
                  data: data.value,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  errorPadding: const EdgeInsets.all(16),
                  backgroundColor: ColorStyles.offWhite,
                  isLoading:
                      voucherListBlocState is GenericListPaginationLoadingState,
                  isEmpty: voucherListBlocState is GenericListEmptyState,
                  emptyText: useLocalizedStrings().voucherListEmpty,
                  emptyIcon: SvgAssets.voucher,
                  retryOnError: loadData,
                  loadData: loadData,
                  showError: voucherListBlocState is GenericListErrorState,
                  errorText: voucherListBlocState is GenericListErrorState
                      ? voucherListBlocState.error.localize(useContext())
                      : null,
                  itemBuilder: (voucher, _, itemContext) {
                    tintColorIndex++;

                    if (tintColorIndex == 4 ||
                        data.value.indexOf(voucher) == 0) {
                      tintColorIndex = 0;
                    }
                    return InkWell(
                      onTap: () =>
                          router.pushVoucherDetailsPage(voucher: voucher),
                      child: Hero(
                        tag: 'voucher_${voucher.id}',
                        child: VoucherCardWidget(
                          imageUrl: voucher.imageUrl,
                          color: voucherTintColors[tintColorIndex],
                          partnerName: voucher.partnerName,
                          voucherName: voucher.campaignName,
                          expirationDate: voucher.expirationDate,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (position) => Container(),
                ),
              ),
            ],
          ),
        ),
        if (voucherListBlocState is GenericListLoadingState)
          const Center(child: Spinner())
      ],
    );
  }
}
