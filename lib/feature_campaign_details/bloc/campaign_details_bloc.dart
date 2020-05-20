import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_details_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/campaign/campaign_repository.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/di/campaign_details_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';

class CampaignDetailsBloc extends GenericDetailsBloc<CampaignResponseModel> {
  CampaignDetailsBloc(this._campaignRepository);

  final CampaignRepository _campaignRepository;

  @override
  Future<CampaignResponseModel> loadData(String identifier) =>
      _campaignRepository.getCampaignDetails(id: identifier);
}

CampaignDetailsBloc useCampaignDetailsBloc() =>
    ModuleProvider.of<CampaignDetailsModule>(useContext()).campaignDetailsBloc;
