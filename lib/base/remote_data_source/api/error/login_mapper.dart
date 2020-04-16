import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

import 'errors.dart';

class LoginMapper extends ExceptionMapper {
  @override
  Exception map(Exception exception) {
    if (exception is! DioError) {
      return exception;
    }

    final dioException = exception as DioError;

    if (dioException.type == DioErrorType.RESPONSE) {
      if (dioException.response?.statusCode == 401) {
        final errorType = EnumMapper.mapFromString(
          dioException.response.data['error'],
          enumValues: ServiceExceptionType.values,
          defaultValue: null,
        );

        if (errorType == ServiceExceptionType.loginAttemptsWarning) {
          LoginAttemptsWarningException serverError;
          try {
            serverError = LoginAttemptsWarningException.fromJson(
                dioException.response.data);
          } catch (e) {
            return null;
          }

          return serverError;
        }
      }

      if (dioException.response?.statusCode == 429) {
        TooManyRequestException serverError;
        try {
          serverError =
              TooManyRequestException.fromJson(dioException.response.data);
        } catch (e) {
          return null;
        }
        return serverError;
      }
    }

    return super.map(dioException);
  }
}
