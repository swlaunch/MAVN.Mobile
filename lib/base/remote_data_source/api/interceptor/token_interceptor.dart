import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/anonymous_access_paths.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';

class TokenInterceptor extends CustomInterceptor {
  TokenInterceptor(this._tokenRepository);

  final TokenRepository _tokenRepository;

  @override
  Future<RequestOptions> onRequest(RequestOptions requestOptions) async {
    if (AnonymousAccessPaths.paths.contains(requestOptions.path)) {
      return requestOptions;
    }

    final token = await _tokenRepository.getLoginToken();

    requestOptions.headers.addAll({'authorization': 'Bearer $token'});

    return requestOptions;
  }
}
