import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
import 'package:latlong/latlong.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/campaign/campaign_repository.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/bloc/campaign_map_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/di/campaign_map_module.dart';
import 'package:lykke_mobile_mavn/feature_location/util/user_position.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc_output.dart';

class CampaignMapBloc extends Bloc<CampaignMapState> {
  CampaignMapBloc(
    this._campaignRepository,
    this._exceptionToMessageMapper,
  );

  static const _pageSize = 100;
  static const double _defaultRadius = 2;

  final CampaignRepository _campaignRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  CampaignMapState initialState() => CampaignMapUninitializedState();

  Future<void> loadCampaignsForLocation({
    @required UserPosition userPosition,
    double radius,
  }) async {
    setState(CampaignMapLoadingState());

    try {
      final campaignListResponse = await _campaignRepository.getCampaigns(
        pageSize: _pageSize,
        currentPage: 1,
        long: userPosition.long,
        lat: userPosition.lat,
        radius: radius ?? _defaultRadius,
      );

      setState(CampaignMapLoadedState(
        campaignList: campaignListResponse.campaigns,
      ));
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);

      setState(CampaignMapErrorState(errorMessage));
    }
  }

  double getRadiusFromRegion(LatLngBounds bounds) {
    final ne = bounds.northeast;
    final sw = bounds.southwest;

    const distance = Distance();
    final double dist = distance(
        LatLng(ne.latitude, ne.longitude), LatLng(sw.latitude, sw.longitude));

    return dist / 2000.0;
  }
}

CampaignMapBloc useCampaignMapBloc() =>
    ModuleProvider.of<CampaignMapModule>(useContext()).campaignMapBloc;
