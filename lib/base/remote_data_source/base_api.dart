import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';

class BaseApi {
  BaseApi(this.httpClient);

  final HttpClient httpClient;

  final ExceptionMapper _defaultExceptionMapper = ExceptionMapper();

  Future<T> exceptionHandledHttpClientRequest<T>(
      Future<T> Function() httpClientRequestFunction,
      {ExceptionMapper mapper}) async {
    try {
      return await httpClientRequestFunction();
    } on Exception catch (e) {
      mapper ??= _defaultExceptionMapper;
      throw mapper.map(e);
    }
  }
}
