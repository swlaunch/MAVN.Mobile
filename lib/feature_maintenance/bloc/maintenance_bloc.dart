import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/maintenance/response_model/maintenance_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/mobile/mobile_repository.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/di/maintenance_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:rxdart/rxdart.dart';

import 'maintenance_bloc_output.dart';

class MaintenanceBloc extends Bloc<MaintenanceState> {
  MaintenanceBloc(this._mobileRepository) {
    startPeriodicCheck();
  }

  final MobileSettingsRepository _mobileRepository;
  static const periodicDuration = Duration(minutes: 15);

  @override
  MaintenanceState initialState() => MaintenanceStateUninitializedState();

  CompositeSubscription compositeSubscription = CompositeSubscription();

  void startPeriodicCheck() {
    compositeSubscription.add(Stream.periodic(periodicDuration)
        .switchMap((_) => Stream.fromFuture(retry()))
        .listen((i) {}));
  }

  void setInitialDurationPeriod(int expectedRemainingDuration) {
    setState(MaintenanceErrorState(_formatDuration(expectedRemainingDuration)));
  }

  Future<void> retry() async {
    setState(MaintenanceLoadingState());

    try {
      //Make a call to an endpoint that does not require authentication
      await _mobileRepository.getSettings();

      setState(MaintenanceSuccessState());
      sendEvent(MaintenanceCloseEvent());
      //TODO: Add analytics event
    } on DioError catch (dioException) {
      if (dioException?.response?.statusCode != 503) {
        setState(MaintenanceErrorState(_formatDuration(null)));
        return;
      }

      final int expectedRemainingDuration =
          MaintenanceResponseModel.fromError(dioException)
              .expectedRemainingDurationInMinutes;

      //TODO: Add analytics event
      setState(
          MaintenanceErrorState(_formatDuration(expectedRemainingDuration)));
    }
  }

  // ignore: lines_longer_than_80_chars
  //TODO: Instead of formatting the duration here, use enum to represent all cases, which the view should format it afterwards
  LocalizedStringBuilder _formatDuration(int durationInMinutes) {
    if (durationInMinutes == null) {
      return LazyLocalizedStrings.maintenanceErrorCoupleOfHours;
    }

    // in case that duration is less than two hours, return 1 hour
    if (durationInMinutes <= 119) {
      return LazyLocalizedStrings.hours(1);
    }

    final durationInHours = Duration(minutes: durationInMinutes).inHours;
    return LazyLocalizedStrings.hours(durationInHours);
  }

  @override
  void dispose() {
    super.dispose();
    compositeSubscription.clear();
  }
}

MaintenanceBloc useMaintenanceBloc() =>
    ModuleProvider.of<MaintenanceModule>(useContext()).maintenanceBloc;
