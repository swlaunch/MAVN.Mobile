import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/completed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/failed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/pending_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/ui_components/tab_bar_layout.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/completed_requests_widget.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/failed_requests_widget.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/pending_requests_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dark_page_title.dart';

class PaymentRequestListPage extends HookWidget {
  const PaymentRequestListPage();

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TabConfiguration(
          title: useLocalizedStrings().transferRequestOngoingTab,
          globalKey: GlobalKey(),
          tabKey: const Key('paymentRequestListOngoingTab'),
          buildWidget: () => const PendingRequestsWidget(
              key: Key('paymentRequestListOngoingList'))),
      TabConfiguration(
          title: useLocalizedStrings().transferRequestCompletedTab,
          globalKey: GlobalKey(),
          tabKey: const Key('paymentRequestListCompletedTab'),
          buildWidget: () => const CompletedRequestsWidget(
              key: Key('paymentRequestListCompletedList'))),
      TabConfiguration(
          title: useLocalizedStrings().transferRequestUnsuccessfulTab,
          globalKey: GlobalKey(),
          tabKey: const Key('paymentRequestListUnsuccessfulTab'),
          buildWidget: () => const FailedRequestsWidget(
              key: Key('paymentRequestListFailedList'))),
    ];

    final partnerPaymentsPendingBloc = usePendingPartnerPaymentsBloc();
    final partnerPaymentsCompletedBloc = usePartnerPaymentsCompletedBloc();
    final partnerPaymentsFailedBloc = useFailedPartnerPaymentsBloc();
    final partnerPaymentsPendingState =
        useBlocState<GenericListState>(partnerPaymentsPendingBloc);
    final partnerPaymentsCompletedState =
        useBlocState<GenericListState>(partnerPaymentsCompletedBloc);
    final partnerPaymentsFailedState =
        useBlocState<GenericListState>(partnerPaymentsFailedBloc);

    void reload() {
      partnerPaymentsPendingBloc.updateGenericList();
      partnerPaymentsCompletedBloc.updateGenericList();
      partnerPaymentsFailedBloc.updateGenericList();
    }

    final isErrorState = [
      partnerPaymentsPendingState,
      partnerPaymentsCompletedState,
      partnerPaymentsFailedState
    ].any((state) => state is BaseNetworkErrorState);

    final children = isErrorState
        ? _buildNetworkErrorState(reload)
        : _buildSuccessState(tabs);
    return ScaffoldWithAppBar(
      useDarkTheme: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  List<Widget> _buildSuccessState(List<TabConfiguration> tabs) => <Widget>[
        DarkPageTitle(
            pageTitle: useLocalizedStrings().transferRequestListPageTitle),
        Expanded(child: TabBarLayout(tabs: tabs)),
      ];

  List<Widget> _buildNetworkErrorState(VoidCallback onRetry) => <Widget>[
        Container(
            color: ColorStyles.primaryDark,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: NetworkErrorWidget(onRetry: onRetry))
      ];
}
