import 'package:lykke_mobile_mavn/feature_campaigns_map/bloc/campaign_map_bloc.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/util/location_to_marker_mapper.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class CampaignMapModule extends Module {
  CampaignMapBloc get campaignMapBloc => get();

  LocationToMarkerMapper get locationToMarkerMapper => get();

  @override
  void provideInstances() {
    provideSingleton(() => CampaignMapBloc(get(), get()));
    provideSingleton(() => LocationToMarkerMapper());
  }
}
