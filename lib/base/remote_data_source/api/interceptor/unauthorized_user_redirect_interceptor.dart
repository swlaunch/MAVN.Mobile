import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/anonymous_access_paths.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:pedantic/pedantic.dart';

class UnauthorizedUserRedirectInterceptor extends CustomInterceptor {
  UnauthorizedUserRedirectInterceptor(
    this.router,
    this.tokenRepository,
    this.userRepository,
    this.localSettingsRepository,
  );

  final Router router;
  final TokenRepository tokenRepository;
  final UserRepository userRepository;
  final LocalSettingsRepository localSettingsRepository;

  @override
  Future<DioError> onError(DioError dioException) async {
    if (dioException == null) {
      return dioException;
    }

    if (dioException.request != null &&
        AnonymousAccessPaths.paths.contains(dioException.request.path)) {
      return dioException;
    }

    if (dioException.response != null &&
        dioException.response.statusCode == 401) {
      await goToLoginPage();
    }

    return dioException;
  }

  Future<void> goToLoginPage() async {
    // If we are already logged out, don't do anything
    // This is useful when we have multiple unauthorized requests in flight
    if (await tokenRepository.getLoginToken() == null) {
      return;
    }

    await tokenRepository.deleteLoginToken();
    await userRepository.wipeData();
    await localSettingsRepository.setUserVerified(isVerified: false);
    await localSettingsRepository.removeEmailVerificationCode();

    unawaited(
        router.navigateToLoginPage(unauthorizedInterceptorRedirection: true));
  }
}
