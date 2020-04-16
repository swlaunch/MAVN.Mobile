import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/maintenance/response_model/maintenance_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';

class MaintenanceInterceptor extends CustomInterceptor {
  MaintenanceInterceptor(this.router);

  final Router router;

  @override
  Future<DioError> onError(DioError err) {
    if (err?.response?.statusCode == 503 &&
        !router.isMaintenancePageCurrentRoute) {
      router.pushRootMaintenancePage(MaintenanceResponseModel.fromError(err));
    }

    return Future.value(err);
  }
}
