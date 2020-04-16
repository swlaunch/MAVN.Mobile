import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/partner_payments_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/di/partner_payments_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class CompletedPartnerPaymentsBloc extends PartnerPaymentsBloc {
  CompletedPartnerPaymentsBloc(this._partnerRepository);

  final PartnerRepository _partnerRepository;

  @override
  Future<PaginatedPartnerPaymentsResponseModel> loadData(int page) =>
      _partnerRepository.getCompletedPayments(currentPage: page);
}

CompletedPartnerPaymentsBloc usePartnerPaymentsCompletedBloc() =>
    ModuleProvider.of<PartnerPaymentsModule>(useContext())
        .completedPartnerPaymentsBloc;
