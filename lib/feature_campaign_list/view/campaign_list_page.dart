import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/bloc/campaign_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/ui_components/campaign_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class CampaignListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final campaignListBloc = useCampaignListBloc();
    final campaignListBlocState = useBlocState(campaignListBloc);
    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    final data = useState(<CampaignResponseModel>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      campaignListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      campaignListBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [campaignListBloc]);

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.offersPageIndex) {
        throttler.throttle(loadInitialData);
      }
    });

    if (campaignListBlocState is GenericListLoadedState) {
      data.value = campaignListBlocState.list;
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
                  campaignListBloc.updateGenericList(refresh: true),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: InfiniteListWidget(
                      data: data.value,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      errorPadding: const EdgeInsets.all(16),
                      backgroundColor: ColorStyles.offWhite,
                      isLoading: campaignListBlocState
                          is GenericListPaginationLoadingState,
                      isEmpty: campaignListBlocState is GenericListEmptyState,
                      emptyText: useLocalizedStrings().voucherListEmpty,
                      emptyIcon: SvgAssets.voucher,
                      retryOnError: loadData,
                      loadData: loadData,
                      showError: campaignListBlocState is GenericListErrorState,
                      errorText: campaignListBlocState is GenericListErrorState
                          ? campaignListBlocState.error.localize(useContext())
                          : null,
                      itemBuilder: (campaign, _, itemContext) => InkWell(
                        onTap: () =>
                            router.pushCampaignDetailsPage(campaign: campaign),
                        child: Hero(
                          tag: 'campaign_${campaign.id}',
                          child: CampaignWidget(
                            title: campaign.name,
                            imageUrl: campaign.imageUrl,
                            price: campaign.price,
                          ),
                        ),
                      ),
                      separatorBuilder: (position) => Container(),
                    ),
                  ),
                ],
              ),
            ),
            if (campaignListBlocState is GenericListLoadingState)
              const Center(child: Spinner())
          ],
        ),
      ),
    );
  }
}
