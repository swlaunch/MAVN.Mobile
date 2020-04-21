import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';

abstract class PartnerPaymentsBloc extends GenericListBloc<
    PaginatedPartnerPaymentsResponseModel, PaymentRequestResponseModel> {
  PartnerPaymentsBloc()
      : super(
            genericErrorSubtitle:
                LazyLocalizedStrings.transferRequestListGenericError);

  @override
  int getCurrentPage(PaginatedPartnerPaymentsResponseModel response) =>
      response.currentPage;

  @override
  List<PaymentRequestResponseModel> getDataFromResponse(
          PaginatedPartnerPaymentsResponseModel response) =>
      response.paymentRequests;

  @override
  int getTotalCount(PaginatedPartnerPaymentsResponseModel response) =>
      response.totalCount;
}
