import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class NetworkException implements Exception {}

enum ServiceExceptionType {
  canNotReferYourself,
  conversionRateNotFound,
  customerBlocked,
  customerDoesNotExist,
  customerPhoneIsMissing,
  customerProfileDoesNotExist,
  customerWalletBlocked,
  customerWalletMissing,
  emailIsAlreadyVerified,
  emailIsNotAllowed,
  identifierMismatch,
  imageUploadError,
  invalidAmount,
  invalidCredentials,
  invalidCustomerId,
  invalidEmailFormat,
  invalidPasswordFormat,
  invalidPrivateAddress,
  invalidPublicAddress,
  invalidReceiver,
  invalidSignature,
  invalidPriceInSpendRule,
  invalidWalletLinkSignature,
  invalidVerticalInSpendRule,
  linkingRequestAlreadyApproved,
  linkingRequestAlreadyExists,
  linkingRequestDoesNotExist,
  loginAlreadyInUse,
  loginAttemptsWarning,
  noCustomerWithSuchEmail,
  notEnoughTokens,
  noVouchersInStock,
  paymentDoesNotExist,
  paymentIsNotInACorrectStatusToBeUpdated,
  paymentRequestsIsForAnotherCustomer,
  phoneAlreadyExists,
  phoneIsAlreadyVerified,
  providedIdentifierHasExpired,
  pinIsNotSet,
  pinCodeMismatch,
  pinAlreadySet,
  reachedMaximumRequestForPeriod,
  referralAlreadyConfirmed,
  referralAlreadyExist,
  referralLeadAlreadyConfirmed,
  referralLeadAlreadyExist,
  referralLeadCustomerIdInvalid,
  referralLeadNotProcessed,
  referralNotFound,
  referralsLimitExceeded,
  senderCustomerNotEnoughBalance,
  senderCustomerNotFound,
  sfAccountAlreadyExisting,
  spendRuleNotFound,
  targetCustomerNotFound,
  thereIsNoIdentifierForThisCustomer,
  tooManyLoginRequest,
  transferSourceAndTargetMustBeDifferent,
  transferSourceCustomerWalletBlocked,
  transferTargetCustomerWalletBlocked,
  verificationCodeDoesNotExist,
  verificationCodeExpired,
  verificationCodeMismatch,
}

class ServiceException extends Equatable implements Exception {
  const ServiceException(this.exceptionType, {this.message});

  factory ServiceException.fromJson(Map<String, dynamic> json) =>
      ServiceException(
        EnumMapper.mapFromString(json['error'],
            enumValues: ServiceExceptionType.values, defaultValue: null),
        message: json['message'],
      );

  final ServiceExceptionType exceptionType;
  final String message;

  @override
  List<Object> get props => [exceptionType, message];
}

class CustomException extends Equatable implements Exception {
  const CustomException(this.message);

  final LocalizedStringBuilder message;

  @override
  List<Object> get props => [message];
}

ServiceExceptionType getServiceExceptionTypeFromString(
  String serverExceptionTypeAsString,
) {
  for (final exceptionType in ServiceExceptionType.values) {
    if (exceptionType.toString().split('.')[1].toLowerCase() ==
        serverExceptionTypeAsString.toLowerCase()) {
      return exceptionType;
    }
  }
  return null;
}
