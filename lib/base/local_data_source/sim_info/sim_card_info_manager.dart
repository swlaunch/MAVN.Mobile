import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

class SimCardInfoManager {
  Future<String> getIso2Code() => FlutterSimCountryCode.simCountryCode;
}
