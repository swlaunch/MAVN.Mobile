import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/completed_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/expired_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/pending_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/view/approved_referral_list_widget.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/view/expired_referral_list_widget.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/view/pending_referral_list_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/main_page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/sliver_tab_layout.dart';

class ReferralListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pendingReferralListBloc = usePendingReferralListBloc();
    final pendingReferralListBlocState = useBlocState(pendingReferralListBloc);
    final approvedReferralListBloc = useCompletedReferralListBloc();
    final approvedReferralListBlocState =
        useBlocState(approvedReferralListBloc);
    final expiredReferralListBloc = useExpiredReferralListBloc();
    final expiredReferralListBlocState = useBlocState(expiredReferralListBloc);

    void reload() {
      pendingReferralListBloc.getList();
      approvedReferralListBloc.getList();
      expiredReferralListBloc.getList();
    }

    final tabs = [
      SliverTabConfiguration(
        title: useLocalizedStrings().referralListOngoingTab,
        globalKey: GlobalKey(),
        tabKey: const Key('referralListPendingTab'),
        buildWidget: () => PendingReferralListWidget(),
        onScroll: () => pendingReferralListBloc.getList(),
      ),
      SliverTabConfiguration(
        title: useLocalizedStrings().referralListCompletedTab,
        globalKey: GlobalKey(),
        tabKey: const Key('referralListApprovedTab'),
        buildWidget: () => ApprovedReferralListWidget(),
        onScroll: () => approvedReferralListBloc.getList(),
      ),
      SliverTabConfiguration(
        title: useLocalizedStrings().referralListExpiredTab,
        globalKey: GlobalKey(),
        tabKey: const Key('referralListExpiredTab'),
        buildWidget: () => ExpiredReferralListWidget(),
        onScroll: () => expiredReferralListBloc.getList(),
      ),
    ];

    final isErrorState = [
      pendingReferralListBlocState,
      approvedReferralListBlocState,
      expiredReferralListBlocState,
    ].any((state) => state is BaseNetworkErrorState);

    final content = isErrorState
        ? _buildNetworkErrorState(reload)
        : _buildSuccessState(tabs);

    return content;
  }

  Widget _buildSuccessState(List<SliverTabConfiguration> tabs) =>
      SliverTabBarLayout(
        tabs: tabs,
        title: MainPageTitle(
          title: useLocalizedStrings().referralListPageTitle,
          subtitle: useLocalizedStrings().referralListPageDescription,
        ),
      );
}

Widget _buildNetworkErrorState(void Function() reload) => ScaffoldWithAppBar(
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: NetworkErrorWidget(onRetry: reload)),
        ],
      ),
    );
