import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class ExceptionToMessageMapper {
  ExceptionToMessageMapper(this._localSettingsRepository);

  final LocalSettingsRepository _localSettingsRepository;

  String map(Exception exception) {
    if (exception is ServiceException) {
      return _getServiceError(exception);
    }

    if (exception is NetworkException) {
      return LocalizedStrings.networkError;
    }

    return _getGenericError();
  }

  String _getGenericError() {
    final String serviceNumber =
        _localSettingsRepository.getMobileSettings()?.supportPhoneNumber;

    return StringUtils.isNullOrEmpty(serviceNumber)
        ? LocalizedStrings.defaultGenericError
        : LocalizedStrings.genericError(serviceNumber);
  }

  String _getServiceError(ServiceException exception) {
    final type = exception.exceptionType;
    final exceptionMessage = exception.message;

    switch (type) {
      case ServiceExceptionType.canNotReferYourself:
        return LocalizedStrings.canNotReferYourselfError;
        break;
      case ServiceExceptionType.conversionRateNotFound:
        return _getGenericError();
        break;
      case ServiceExceptionType.customerBlocked:
        return LocalizedStrings.customerBlockedError;
        break;
      case ServiceExceptionType.customerDoesNotExist:
        return LocalizedStrings.customerDoesNotExistError;
        break;
      case ServiceExceptionType.customerPhoneIsMissing:
        return LocalizedStrings.customerPhoneIsMissingError;
        break;
      case ServiceExceptionType.customerProfileDoesNotExist:
        return LocalizedStrings.customerProfileDoesNotExistError;
        break;
      case ServiceExceptionType.customerWalletBlocked:
        return LocalizedStrings.customerWalletBlockedError;
        break;
      case ServiceExceptionType.customerWalletMissing:
        return exceptionMessage;
        break;
      case ServiceExceptionType.emailIsAlreadyVerified:
        return LocalizedStrings.emailIsAlreadyVerifiedError;
        break;
      case ServiceExceptionType.emailIsNotAllowed:
        return exceptionMessage;
        break;
      case ServiceExceptionType.identifierMismatch:
        return exceptionMessage;
        break;
      case ServiceExceptionType.imageUploadError:
        return exceptionMessage;
        break;
      case ServiceExceptionType.invalidAmount:
        return LocalizedStrings.invalidAmountError;
        break;
      case ServiceExceptionType.invalidCredentials:
        return LocalizedStrings.invalidCredentialsError;
        break;
      case ServiceExceptionType.invalidCustomerId:
        return exceptionMessage;
        break;
      case ServiceExceptionType.invalidEmailFormat:
        return LocalizedStrings.invalidEmailFormatError;
        break;
      case ServiceExceptionType.invalidPasswordFormat:
        return LocalizedStrings.invalidPasswordFormatError;
        break;
      case ServiceExceptionType.invalidPrivateAddress:
        return LocalizedStrings.invalidPrivateAddressError;
        break;
      case ServiceExceptionType.invalidPublicAddress:
        return LocalizedStrings.invalidPublicAddressError;
        break;
      case ServiceExceptionType.invalidReceiver:
        return exceptionMessage;
        break;
      case ServiceExceptionType.invalidSignature:
        return LocalizedStrings.invalidSignatureError;
        break;
      case ServiceExceptionType.invalidPriceInSpendRule:
        return _getGenericError();
        break;
      case ServiceExceptionType.invalidWalletLinkSignature:
        return LocalizedStrings.invalidWalletLinkSignatureError;
        break;
      case ServiceExceptionType.invalidVerticalInSpendRule:
        return _getGenericError();
        break;
      case ServiceExceptionType.linkingRequestAlreadyApproved:
        return LocalizedStrings.linkingRequestAlreadyApprovedError;
        break;
      case ServiceExceptionType.linkingRequestAlreadyExists:
        return LocalizedStrings.linkingRequestAlreadyExistsError;
        break;
      case ServiceExceptionType.linkingRequestDoesNotExist:
        return LocalizedStrings.linkingRequestDoesNotExistError;
        break;
      case ServiceExceptionType.loginAlreadyInUse:
        return LocalizedStrings.loginAlreadyInUseError;
        break;
      case ServiceExceptionType.loginAttemptsWarning:
        return exception is LoginAttemptsWarningException
            ? LocalizedStrings.loginPageLoginAttemptWarningMessage(
                exception.attemptsLeft)
            : exceptionMessage;
        break;
      case ServiceExceptionType.noCustomerWithSuchEmail:
        return LocalizedStrings.noCustomerWithSuchEmailError;
        break;
      case ServiceExceptionType.notEnoughTokens:
        return LocalizedStrings.notEnoughTokensError(
            _localSettingsRepository.getMobileSettings()?.tokenSymbol);
        break;
      case ServiceExceptionType.noVouchersInStock:
        return LocalizedStrings.noVouchersInStockError;
        break;
      case ServiceExceptionType.paymentDoesNotExist:
        return LocalizedStrings.paymentDoesNotExistError;
        break;
      case ServiceExceptionType.paymentIsNotInACorrectStatusToBeUpdated:
        return LocalizedStrings.paymentIsNotInACorrectStatusToBeUpdatedError;
        break;
      case ServiceExceptionType.paymentRequestsIsForAnotherCustomer:
        return LocalizedStrings.paymentRequestsIsForAnotherCustomerError;
        break;
      case ServiceExceptionType.phoneAlreadyExists:
        return LocalizedStrings.phoneAlreadyExistsError;
        break;
      case ServiceExceptionType.phoneIsAlreadyVerified:
        return LocalizedStrings.phoneIsAlreadyVerifiedError;
        break;
      case ServiceExceptionType.providedIdentifierHasExpired:
        return exceptionMessage;
        break;
      case ServiceExceptionType.reachedMaximumRequestForPeriod:
        return exceptionMessage;
        break;
      case ServiceExceptionType.referralAlreadyConfirmed:
        return LocalizedStrings.referralAlreadyConfirmedError;
        break;
      case ServiceExceptionType.referralAlreadyExist:
        return LocalizedStrings.referralAlreadyExistError;
        break;
      case ServiceExceptionType.referralLeadAlreadyConfirmed:
        return LocalizedStrings.referralLeadAlreadyConfirmedError;
        break;
      case ServiceExceptionType.referralLeadAlreadyExist:
        return LocalizedStrings.referralLeadAlreadyExistError;
        break;
      case ServiceExceptionType.referralLeadCustomerIdInvalid:
        return exceptionMessage;
        break;
      case ServiceExceptionType.referralLeadNotProcessed:
        return exceptionMessage;
        break;
      case ServiceExceptionType.referralNotFound:
        return LocalizedStrings.referralNotFoundError;
        break;
      case ServiceExceptionType.referralsLimitExceeded:
        return LocalizedStrings.referralsLimitExceededError;
        break;
      case ServiceExceptionType.senderCustomerNotEnoughBalance:
        return exceptionMessage;
        break;
      case ServiceExceptionType.senderCustomerNotFound:
        return LocalizedStrings.senderCustomerNotFoundError;
        break;
      case ServiceExceptionType.sfAccountAlreadyExisting:
        return exceptionMessage;
        break;
      case ServiceExceptionType.spendRuleNotFound:
        return _getGenericError();
        break;
      case ServiceExceptionType.targetCustomerNotFound:
        return LocalizedStrings.targetCustomerNotFoundError;
        break;
      case ServiceExceptionType.thereIsNoIdentifierForThisCustomer:
        return exceptionMessage;
        break;
      case ServiceExceptionType.tooManyLoginRequest:
        return exception is TooManyRequestException
            ? LocalizedStrings.loginPageTooManyRequestMessage(
                exception.retryPeriodInMinutes)
            : LocalizedStrings.tooManyLoginRequestError;
        break;
      case ServiceExceptionType.transferSourceAndTargetMustBeDifferent:
        return LocalizedStrings.transferSourceAndTargetMustBeDifferentError;
        break;
      case ServiceExceptionType.transferSourceCustomerWalletBlocked:
        return LocalizedStrings.transferSourceCustomerWalletBlockedError;
        break;
      case ServiceExceptionType.transferTargetCustomerWalletBlocked:
        return LocalizedStrings.transferTargetCustomerWalletBlockedError;
        break;
      case ServiceExceptionType.verificationCodeDoesNotExist:
        return LocalizedStrings.verificationCodeDoesNotExistError;
        break;
      case ServiceExceptionType.verificationCodeExpired:
        return LocalizedStrings.verificationCodeExpiredError;
        break;
      case ServiceExceptionType.verificationCodeMismatch:
        return LocalizedStrings.verificationCodeMismatchError;
        break;
      case ServiceExceptionType.pinIsNotSet:
        return exceptionMessage;
      case ServiceExceptionType.pinCodeMismatch:
        return LocalizedStrings.pinErrorIncorrectPassCode;
      case ServiceExceptionType.pinAlreadySet:
        return exceptionMessage;
    }

    return exceptionMessage;
  }
}

ExceptionToMessageMapper useExceptionToMessageMapper(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).getExceptionToMessageMapper;
