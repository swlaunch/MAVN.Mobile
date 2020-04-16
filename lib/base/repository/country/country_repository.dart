import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/country_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';

class CountryRepository {
  CountryRepository(this._countryApi);

  final CountryApi _countryApi;

  Future<CountryListResponseModel> getCountryList() =>
      _countryApi.getCountryList();

  Future<CountryCodeListResponseModel> getCountryCodeList() =>
      _countryApi.getCountryCodeList();
}
