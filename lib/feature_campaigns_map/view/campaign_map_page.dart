import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/bloc/campaign_map_bloc.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/bloc/campaign_map_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/ui_components/pop_back_button.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/util/location_to_marker_mapper.dart';
import 'package:lykke_mobile_mavn/feature_location/bloc/user_location_bloc.dart';
import 'package:lykke_mobile_mavn/feature_location/bloc/user_location_bloc_state.dart';
import 'package:lykke_mobile_mavn/feature_location/util/user_position.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:pedantic/pedantic.dart';

class CampaignMapPage extends HookWidget {
  static const _defaultInitialPosition = LatLng(47.3769, 8.5417);

  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final localizedStrings = useLocalizedStrings();

    final userLocationBloc = useUserLocationBloc();
    final userLocationState = useBlocState(userLocationBloc);

    final campaignMapBloc = useCampaignMapBloc();
    final campaignMapBlocState = useBlocState(campaignMapBloc);
    final mapper = useLocationToMarkerMapper();

    final isErrorDismissed = useState(false);
    final isReturningFromSettings = useState(false);
    final currentUserLocation = useState<UserPosition>();
    final data = useState<List<Marker>>([]);

    useEffect(() {
      userLocationBloc.getUserLocation();
    }, [userLocationBloc]);

    useBlocEventListener(userLocationBloc, (event) async {
      if (event is UserLocationFetchedLocationEvent) {
        isErrorDismissed.value = false;

        ///load campaigns for this location
        unawaited(campaignMapBloc.loadCampaignsForLocation(
            userPosition: event.userPosition));
        currentUserLocation.value = event.userPosition;

        ///animate to user location
        unawaited(
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  currentUserLocation.value.lat,
                  currentUserLocation.value.long,
                ),
                zoom: 100,
              ),
            ),
          ),
        );

        return;
      }

      ///if location is disabled, show prompt
      else if (event is UserLocationServiceDisabledEvent) {
        final result = await router.showEnableLocationsDialog(localizedStrings);

        ///if user won't enable location
        ///do not prompt them again
        if (result) {
          isReturningFromSettings.value = true;
          await AppSettings.openLocationSettings();
        } else {
          userLocationBloc.stopUsingLocation();
        }

        ///TODO show all Switzerland
      }
    });

    void _onMapCreated(GoogleMapController controller) {
      _mapController = controller;
    }

    if (campaignMapBlocState is CampaignMapLoadedState) {
      data.value = mapper.mapCampaignsToMarkers(
          campaignMapBlocState.campaignList, () => null)
        ..add(Marker(
          markerId: MarkerId('me'),
          position: LatLng(
            currentUserLocation.value.lat,
            currentUserLocation.value.long,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ));
    }

    Future<void> onCameraIdle() async {
      final bounds = await _mapController.getVisibleRegion();
      final centerLat =
          (bounds.northeast.latitude + bounds.southwest.latitude) / 2.0;
      final centerLng =
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2.0;
      final radius = campaignMapBloc.getRadiusFromRegion(bounds);

      unawaited(campaignMapBloc.loadCampaignsForLocation(
          userPosition: UserPosition(lat: centerLat, long: centerLng),
          radius: radius));
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  const CameraPosition(target: _defaultInitialPosition),
              myLocationEnabled: false,
              markers: data.value.toSet(),
              onCameraIdle: onCameraIdle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: FloatingBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  CameraPosition _getInitialCameraPosition(
      UserLocationState userLocationState) {
    final location = userLocationState is UserLocationLoadedState
        ? LatLng(userLocationState.userPosition.lat,
            userLocationState.userPosition.long)
        : _defaultInitialPosition;
    return CameraPosition(target: location);
  }
}
