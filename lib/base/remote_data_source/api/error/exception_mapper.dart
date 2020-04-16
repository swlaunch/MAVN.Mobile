import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';

class ExceptionMapper {
  Exception _mapErrorResponseToException(Response response) {
    ServiceException serverError;
    try {
      if (response.data is String) {
        serverError = ServiceException.fromJson(json.decode(response.data));
      } else {
        serverError = ServiceException.fromJson(response.data);
      }
    } catch (e) {
      return null;
    }

    if (serverError.exceptionType != null) {
      return serverError;
    }

    return null;
  }

  Exception map(Exception exception) {
    if (exception is! DioError) {
      return exception;
    }

    final dioException = exception as DioError;

    if (dioException.type == DioErrorType.RESPONSE) {
      final handledException =
          _mapErrorResponseToException(dioException.response);

      if (handledException != null) {
        return handledException;
      }
    }

    if (dioException.type == DioErrorType.CONNECT_TIMEOUT ||
        dioException.type == DioErrorType.RECEIVE_TIMEOUT ||
        (dioException.type == DioErrorType.DEFAULT &&
            dioException.message != null &&
            dioException.message.contains('SocketException'))) {
      return NetworkException();
    }

    return exception;
  }
}
