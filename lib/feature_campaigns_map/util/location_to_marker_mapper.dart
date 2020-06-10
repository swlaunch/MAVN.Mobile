import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/di/campaign_map_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LocationToMarkerMapper {
  List<Marker> mapCampaignsToMarkers(
    List<CampaignResponseModel> campaigns,
    VoidCallback onMarkerTap,
  ) {
    final allPartnerLocations = campaigns
        .map((camp) => camp.locations
            .map((location) => _PartnerLocation(camp.partnerName, location))
            .toList())
        .expand((element) => element)
        .toSet()
        .toList();

    final markers = allPartnerLocations
        .map((e) => Marker(
              markerId: MarkerId('${e.partnerName}${e.location.long}'),
              position: LatLng(e.location.lat, e.location.long),
              consumeTapEvents: true,
              onTap: onMarkerTap,
            ))
        .toList();
    return markers;
  }
}

LocationToMarkerMapper useLocationToMarkerMapper() =>
    ModuleProvider.of<CampaignMapModule>(useContext()).locationToMarkerMapper;

class _PartnerLocation {
  _PartnerLocation(this.partnerName, this.location);

  final String partnerName;
  final Geolocation location;
}
