import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/spend_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/spend_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/chips/generic_chip.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/offer_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class SpendRuleListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final analyticsManager = useSpendAnalyticsManager();

    final spendRuleListBloc = useSpendRuleListBloc();
    final spendRuleListBlocState = useBlocState(spendRuleListBloc);
    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    final data = useState(<SpendRule>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      spendRuleListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      spendRuleListBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [spendRuleListBloc]);

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.offersPageIndex) {
        throttler.throttle(loadInitialData);
      }
    });

    if (spendRuleListBlocState is GenericListLoadedState) {
      data.value = spendRuleListBlocState.list;
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: ColorStyles.gold1,
          onRefresh: () async =>
              spendRuleListBloc.updateGenericList(refresh: true),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InfiniteListWidget(
                  data: data.value,
                  padding: const EdgeInsets.all(0),
                  errorPadding: const EdgeInsets.all(16),
                  backgroundColor: ColorStyles.offWhite,
                  isLoading: spendRuleListBlocState
                      is GenericListPaginationLoadingState,
                  isEmpty: spendRuleListBlocState is GenericListEmptyState,
                  emptyText: useLocalizedStrings().spendRulePageEmpty,
                  emptyIcon: SvgAssets.spend,
                  retryOnError: loadData,
                  loadData: loadData,
                  showError: spendRuleListBlocState is GenericListErrorState,
                  errorText: spendRuleListBlocState is GenericListErrorState
                      ? spendRuleListBlocState.error.localize(useContext())
                      : null,
                  itemBuilder: (spendRule, _, itemContext) => OfferListItem(
                    imageUrl: spendRule.imageUrl,
                    title: spendRule.title,
                    subtitle:
                        _buildSubtitleText(itemContext, spendRule.soldCount),
                    onTap: () {
                      analyticsManager.redeemRuleTapped(
                        businessVertical: spendRule.type,
                        offerId: spendRule.id,
                      );
                      router.pushSpendDetailsByType(spendRule);
                    },
                    chip: GenericChip(
                      chipContentWidget:
                          _buildChipContent(itemContext, spendRule.stockCount),
                    ),
                  ),
                  separatorBuilder: (position) => Container(),
                ),
              ),
            ],
          ),
        ),
        if (spendRuleListBlocState is GenericListLoadingState)
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
