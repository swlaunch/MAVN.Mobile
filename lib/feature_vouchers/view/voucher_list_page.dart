import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/voucher_to_item_mapper.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/view/voucher_list_item.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/list_date_header.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class VoucherListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final voucherListBloc = useVoucherListBloc();
    final voucherListBlocState = useBlocState(voucherListBloc);

    final voucherMapper = useVoucherMapper();
    final data = useState(<VoucherListItem>[]);
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
      data.value =
          voucherMapper.mapVouchers(context, voucherListBlocState.list);
    }

    final body = voucherListBlocState is GenericListNetworkErrorState
        ? _buildNetworkError(loadInitialData)
        : _buildContent(voucherListBloc, data, voucherListBlocState, loadData);

    return ScaffoldWithAppBar(body: body);
  }

  Widget _buildContent(
    VoucherListBloc voucherListBloc,
    ValueNotifier<List<VoucherListItem>> data,
    GenericListState voucherListBlocState,
    VoidCallback loadData,
  ) =>
      Stack(
        children: [
          RefreshIndicator(
            color: ColorStyles.gold1,
            onRefresh: () async =>
                voucherListBloc.updateGenericList(refresh: true),
            child: Column(
              children: <Widget>[
                PageTitle(
                  title: useLocalizedStrings().vouchersOption,
                  assetIconLeading: SvgAssets.voucher,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: InfiniteListWidget(
                    data: data.value,
                    padding: const EdgeInsets.all(0),
                    errorPadding: const EdgeInsets.all(16),
                    backgroundColor: ColorStyles.offWhite,
                    isLoading: voucherListBlocState
                        is GenericListPaginationLoadingState,
                    isEmpty: voucherListBlocState is GenericListEmptyState,
                    emptyText: useLocalizedStrings().voucherListEmpty,
                    emptyIcon: SvgAssets.voucher,
                    retryOnError: loadData,
                    loadData: loadData,
                    showError: voucherListBlocState is GenericListErrorState,
                    errorText: voucherListBlocState is GenericListErrorState
                        ? voucherListBlocState.error.localize(useContext())
                        : null,
                    itemBuilder: (item, _, itemContext) {
                      if (item is VoucherListVoucher) {
                        return VoucherListItemView(item);
                      }
                      return ListDateHeader(text: item.formattedDate);
                    },
                    separatorBuilder: (position) {
                      //putting separator only between vouchers
                      if (data.value[position] is VoucherListVoucher) {
                        return StandardDivider();
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (voucherListBlocState is GenericListLoadingState)
            const Center(child: Spinner())
        ],
      );

  Widget _buildNetworkError(VoidCallback reload) => Container(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          children: <Widget>[
            NetworkErrorWidget(onRetry: reload),
          ],
        ),
      );
}
