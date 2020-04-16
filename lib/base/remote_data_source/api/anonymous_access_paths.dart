import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';

class AnonymousAccessPaths {
  static const List<String> paths = [
    CustomerApi.loginPath,
    CustomerApi.registerPath
  ];
}
