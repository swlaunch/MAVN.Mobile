import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/di/referral_list_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PendingReferralListBloc extends ReferralListBloc {
  PendingReferralListBloc(this._referralRepository);

  final ReferralRepository _referralRepository;

  @override
  Future<ReferralsListResponseModel> loadData(int page) =>
      _referralRepository.getPendingReferrals(currentPage: page);
}

PendingReferralListBloc usePendingReferralListBloc() =>
    ModuleProvider.of<ReferralListModule>(useContext()).pendingReferralListBloc;
