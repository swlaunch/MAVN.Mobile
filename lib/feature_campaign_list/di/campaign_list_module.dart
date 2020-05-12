import 'package:lykke_mobile_mavn/feature_campaign_list/bloc/campaign_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class CampaignListModule extends Module {
  CampaignListBloc get campaignListBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => CampaignListBloc(get()));
  }
}
