import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/chips/generic_chip.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/offer_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class VoucherListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final voucherListBloc = useVoucherListBloc();
    final voucherListBlocState = useBlocState(voucherListBloc);
    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

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

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.offersPageIndex) {
        throttler.throttle(loadInitialData);
      }
    });

    if (voucherListBlocState is GenericListLoadedState) {
      data.value = voucherListBlocState.list;
    }

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
                  padding: const EdgeInsets.all(0),
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
                  itemBuilder: (voucher, _, itemContext) => OfferListItem(
                    title: voucher.name,
                    subtitle:
                        _buildSubtitleText(itemContext, voucher.boughtCount),
                    onTap: () {
                      //TODO show voucher details
                    },
                    chip: GenericChip(
                      chipContentWidget:
                          _buildChipContent(itemContext, voucher.totalCount),
                    ),
                  ),
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

  Widget _buildChipContent(BuildContext context, int stockCount) {
    if (stockCount == null) {
      return null;
    }
    return Text(
      LocalizedStrings.of(context).voucherStockCount(stockCount).toLowerCase(),
      style: TextStyles.darkBodyBody3Regular,
    );
  }

  String _buildSubtitleText(BuildContext context, int soldCount) {
    if (soldCount == null || soldCount <= 0) {
      return null;
    }

    return LocalizedStrings.of(context).voucherSoldCountInfo(soldCount);
  }
}
