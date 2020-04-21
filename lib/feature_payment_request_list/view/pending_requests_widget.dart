import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/completed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/failed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/pending_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/paginated_payment_request_list.dart';
import 'package:pedantic/pedantic.dart';

class PendingRequestsWidget extends HookWidget {
  const PendingRequestsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final partnerPaymentsPendingBloc = usePendingPartnerPaymentsBloc();
    final partnerPaymentsCompletedBloc = usePartnerPaymentsCompletedBloc();
    final partnerPaymentsFailedBloc = useFailedPartnerPaymentsBloc();

    Future<void> openPendingPaymentRequest(
        PaymentRequestResponseModel paymentRequestResponseModel) async {
      if (paymentRequestResponseModel.status != PaymentRequestStatus.pending) {
        return;
      }
      final shouldUpdateData = await router
          .pushPaymentRequestPage(paymentRequestResponseModel.paymentRequestId);
      if (shouldUpdateData == true) {
        unawaited(partnerPaymentsPendingBloc.updateGenericList());
        unawaited(partnerPaymentsCompletedBloc.updateGenericList());
        unawaited(partnerPaymentsFailedBloc.updateGenericList());
      }
    }

    return PaginatedRequestsListWidget(
      key: const Key('pendingRequestsList'),
      useBloc: () => usePendingPartnerPaymentsBloc(),
      emptyStateText: useLocalizedStrings().transferRequestEmptyOngoing,
      onItemTap: openPendingPaymentRequest,
    );
  }
}
