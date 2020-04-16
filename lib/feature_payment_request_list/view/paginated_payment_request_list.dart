import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/partner_payments_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/ui_components/payment_request_list_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

typedef UseBlocFunction = PartnerPaymentsBloc Function();

class PaginatedRequestsListWidget extends HookWidget {
  const PaginatedRequestsListWidget({
    @required this.useBloc,
    @required this.emptyStateText,
    this.onItemTap,
    Key key,
  }) : super(key: key);
  final UseBlocFunction useBloc;
  final String emptyStateText;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    final partnerPaymentsBloc = useBloc();
    final partnerPaymentsState =
        useBlocState<GenericListState>(partnerPaymentsBloc);

    final data = useState(<PaymentRequestResponseModel>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      partnerPaymentsBloc.updateGenericList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      partnerPaymentsBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [partnerPaymentsBloc]);

    if (partnerPaymentsState is GenericListLoadedState) {
      data.value = partnerPaymentsState.list;
    }
    return PaymentRequestListWidget(
      data: data.value,
      loadData: loadData,
      isInitiallyLoading: partnerPaymentsState is GenericListLoadingState,
      isLoading: partnerPaymentsState is GenericListPaginationLoadingState,
      isEmpty: partnerPaymentsState is GenericListEmptyState,
      emptyStateText: emptyStateText,
      showError: partnerPaymentsState is GenericListErrorState,
      errorText: partnerPaymentsState is GenericListErrorState
          ? partnerPaymentsState.error
          : '',
      retryOnError: loadData,
      refreshCallback: () async =>
          partnerPaymentsBloc.updateGenericList(refresh: true),
      onItemTap: onItemTap,
    );
  }
}
