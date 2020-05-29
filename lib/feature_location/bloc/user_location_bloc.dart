import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:location/location.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/feature_location/bloc/user_location_bloc_state.dart';
import 'package:lykke_mobile_mavn/feature_location/util/user_position.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class UserLocationBloc extends Bloc<UserLocationState> {
  UserLocationBloc(this._location);

  final Location _location;

  @override
  UserLocationState initialState() => UserLocationUninitializedState();

  Future<void> getUserLocation() async {
    ///if user has not enabled location
    ///or has denied permission
    ///in this run of the app
    ///do not attempt to get location again
    if (currentState is UserLocationPermissionDeniedState ||
        currentState is UserLocationDoNotUseLocationState) {
      ///let the caller know that no location will be provided
      sendEvent(UserLocationDoNotUseLocationEvent());
      return;
    }

    final serviceEnabled = await _checkServiceEnabled();

    ///If service is disabled, [_checkServiceEnabled] has already set the state,
    ///nothing else to do
    if (!serviceEnabled) return;

    ///Permission is either denied now or denied forever, do nothing
    if (!await _checkPermissionGranted()) return;

    ///at this point location service is available and permission is granted

    final location = await _location.getLocation();
    setState(
      UserLocationLoadedState(
        userPosition:
            UserPosition(long: location.longitude, lat: location.latitude),
      ),
    );

    sendEvent(UserLocationFetchedLocationEvent(
      userPosition:
          UserPosition(long: location.longitude, lat: location.latitude),
    ));
  }

  ///set a state that will stop any further location usage
  ///on this run
  void stopUsingLocation() {
    setState(UserLocationDoNotUseLocationState());
  }

  Future<bool> _checkServiceEnabled() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      setState(UserLocationServiceDisabledState());
      sendEvent(UserLocationServiceDisabledEvent());
    }
    return serviceEnabled;
  }

  Future<bool> _checkPermissionGranted() async {
    final hasPermission =
        await _location.hasPermission() == PermissionStatus.granted ||
            await _location.requestPermission() == PermissionStatus.granted;
    setState(hasPermission
        ? UserLocationPermissionGrantedState()
        : UserLocationPermissionDeniedState());
    if (!hasPermission) {
      sendEvent(UserLocationPermissionDeniedEvent());
    }
    return hasPermission;
  }
}

UserLocationBloc useUserLocationBloc() =>
    ModuleProvider.of<AppModule>(useContext()).userLocationBloc;
