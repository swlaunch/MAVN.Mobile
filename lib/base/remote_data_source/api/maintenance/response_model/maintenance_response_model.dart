import 'package:dio/dio.dart';

class MaintenanceResponseModel {
  MaintenanceResponseModel.fromError(DioError error)
      : message = error?.response?.data['Message'],
        plannedDurationInMinutes =
            error?.response?.data['PlannedDurationInMinutes'],
        expectedRemainingDurationInMinutes =
            error?.response?.data['ExpectedRemainingDurationInMinutes'];

  final String message;
  final int plannedDurationInMinutes;
  final int expectedRemainingDurationInMinutes;
}
