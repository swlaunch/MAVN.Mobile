import 'package:lykke_mobile_mavn/feature_campaign_details/bloc/campaign_details_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class CampaignDetailsModule extends Module {
  CampaignDetailsBloc get campaignDetailsBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => CampaignDetailsBloc(get()));
  }
}
