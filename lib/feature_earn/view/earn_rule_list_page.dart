import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/earn_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn/analytics/earn_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/chips/amount_chip.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/offer_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

class EarnRuleListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final analyticsManager = useEarnAnalyticsManager();

    final earnRuleListBloc = useEarnRuleListBloc();
    final earnRuleListBlocState = useBlocState(earnRuleListBloc);

    final data = useState(<EarnRule>[]);
    final isErrorDismissed = useState(false);
    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    void loadData() {
      isErrorDismissed.value = false;
      earnRuleListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      earnRuleListBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [earnRuleListBloc]);

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.offersPageIndex) {
        throttler.throttle(loadInitialData);
      }
    });

    if (earnRuleListBlocState is GenericListLoadedState) {
      data.value = earnRuleListBlocState.list;
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: ColorStyles.gold1,
          onRefresh: () async =>
              earnRuleListBloc.updateGenericList(refresh: true),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InfiniteListWidget(
                  data: data.value,
                  padding: const EdgeInsets.all(0),
                  errorPadding: const EdgeInsets.all(16),
                  backgroundColor: ColorStyles.offWhite,
                  isLoading: earnRuleListBlocState
                      is GenericListPaginationLoadingState,
                  isEmpty: earnRuleListBlocState is GenericListEmptyState,
                  emptyText: useLocalizedStrings().earnRulePageEmpty,
                  emptyIcon: SvgAssets.earn,
                  retryOnError: loadData,
                  loadData: loadData,
                  showError: earnRuleListBlocState is GenericListErrorState,
                  errorText: earnRuleListBlocState is GenericListErrorState
                      ? earnRuleListBlocState.error.localize(useContext())
                      : null,
                  itemBuilder: (earnRule, _, itemContext) => OfferListItem(
                    imageUrl: earnRule.imageUrl,
                    title: earnRule.title,
                    chip: AmountChip(
                      amount: earnRule.reward.value,
                      showAsterisk: earnRule.isApproximate,
                      textStyle: TextStyles.darkBodyBody3Regular,
                    ),
                    onTap: () {
                      analyticsManager.earnRuleTapped(
                          conditionType:
                              ListUtils.isNullOrEmpty(earnRule.conditions)
                                  ? null
                                  : earnRule.conditions?.first?.type,
                          offerId: earnRule.id);
                      router.pushEarnRuleDetailsPage(earnRule);
                    },
                  ),
                  separatorBuilder: (position) => Container(),
                ),
              ),
            ],
          ),
        ),
        if (earnRuleListBlocState is GenericListLoadingState)
          const Center(child: Spinner())
      ],
    );
  }
}
