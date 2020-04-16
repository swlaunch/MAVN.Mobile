import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class CountryApi extends BaseApi {
  CountryApi(HttpClient httpClient) : super(httpClient);

  static const String countryPath = '/lists/countriesOfResidence';
  static const String countryCodesPath = '/lists/countryPhoneCodes';

  Future<CountryListResponseModel> getCountryList() =>
      exceptionHandledHttpClientRequest(() async {
        final countryListResponse = await httpClient.get(countryPath);

        return CountryListResponseModel.fromJson(countryListResponse.data);
      });

  Future<CountryCodeListResponseModel> getCountryCodeList() =>
      exceptionHandledHttpClientRequest(() async {
        final countryCodeListResponse = await httpClient.get(countryCodesPath);

        return CountryCodeListResponseModel.fromJson(
            countryCodeListResponse.data);
      });
}
