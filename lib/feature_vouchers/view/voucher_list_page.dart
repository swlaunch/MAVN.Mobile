import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/ui_components/voucher_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class VoucherListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
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

    return Scaffold(
      backgroundColor: ColorStyles.alabaster,
      appBar: AppBar(
        title: Text(
          useLocalizedStrings().offers,
          style: TextStyles.h1PageHeader,
        ),
        backgroundColor: ColorStyles.alabaster,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
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
                      itemBuilder: (voucher, _, itemContext) => InkWell(
                        onTap: () =>
                            router.pushVoucherDetailsPage(voucher: voucher),
                        child: Hero(
                          tag: 'voucher_${voucher.id}',
                          child: VoucherWidget(
                            title: voucher.name,
                            imageUrl: voucher.getImageUrl(),
                            price: voucher.price,
                          ),
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
        ),
      ),
    );
  }
}
