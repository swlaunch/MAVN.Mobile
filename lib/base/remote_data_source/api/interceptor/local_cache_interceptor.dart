import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';

class LocalCacheInterceptor extends CustomInterceptor {
  LocalCacheInterceptor(this._localSettings);

  final LocalSettingsRepository _localSettings;

  @override
  Future<dynamic> onResponse(Response response) {
    if (response.request.path == CustomerApi.getCustomerPath) {
      _cacheHasPIN(CustomerResponseModel.fromJson(response.data));
    }

    return super.onResponse(response);
  }

  void _cacheHasPIN(CustomerResponseModel customer) =>
      _localSettings.setHasPIN(hasPIN: customer.hasPin);
}
