import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';

class LoginAttemptsWarningException extends ServiceException {
  const LoginAttemptsWarningException(exceptionType,
      {message, this.attemptsLeft})
      : super(exceptionType, message: message);

  factory LoginAttemptsWarningException.fromJson(Map<String, dynamic> json) =>
      LoginAttemptsWarningException(
        ServiceExceptionType.loginAttemptsWarning,
        message: json['message'],
        attemptsLeft: json['attemptsLeft'],
      );
  final int attemptsLeft;
}

class TooManyRequestException extends ServiceException {
  const TooManyRequestException(exceptionType,
      {message, this.retryPeriodInMinutes})
      : super(exceptionType, message: message);

  factory TooManyRequestException.fromJson(Map<String, dynamic> json) =>
      TooManyRequestException(
        ServiceExceptionType.tooManyLoginRequest,
        message: json['message'],
        retryPeriodInMinutes: json['retryPeriodInMinutes'],
      );
  final int retryPeriodInMinutes;
}
