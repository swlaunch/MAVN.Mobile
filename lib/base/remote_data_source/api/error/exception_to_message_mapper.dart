import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_errors.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class ExceptionToMessageMapper {
  ExceptionToMessageMapper(this._localSettingsRepository);

  final LocalSettingsRepository _localSettingsRepository;

  LocalizedStringBuilder map(Exception exception) {
    if (exception is ServiceException) {
      return _getServiceError(exception);
    }

    if (exception is NetworkException) {
      return LazyLocalizedStrings.networkError;
    }

    return _getGenericError();
  }

  LocalizedStringBuilder _getGenericError() {
    final String serviceNumber =
        _localSettingsRepository.getMobileSettings()?.supportPhoneNumber;

    return StringUtils.isNullOrEmpty(serviceNumber)
        ? LazyLocalizedStrings.defaultGenericError
        : LazyLocalizedStrings.genericError(serviceNumber);
  }

  LocalizedStringBuilder _getServiceError(ServiceException exception) {
    final type = exception.exceptionType;
    final exceptionMessage = exception.message;

    switch (type) {
      case ServiceExceptionType.canNotReferYourself:
        return LazyLocalizedStrings.canNotReferYourselfError;
        break;
      case ServiceExceptionType.conversionRateNotFound:
        return _getGenericError();
        break;
      case ServiceExceptionType.customerBlocked:
        return LazyLocalizedStrings.customerBlockedError;
        break;
      case ServiceExceptionType.customerDoesNotExist:
        return LazyLocalizedStrings.customerDoesNotExistError;
        break;
      case ServiceExceptionType.customerPhoneIsMissing:
        return LazyLocalizedStrings.customerPhoneIsMissingError;
        break;
      case ServiceExceptionType.customerProfileDoesNotExist:
        return LazyLocalizedStrings.customerProfileDoesNotExistError;
        break;
      case ServiceExceptionType.customerWalletBlocked:
        return LazyLocalizedStrings.customerWalletBlockedError;
        break;
      case ServiceExceptionType.customerWalletMissing:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.emailIsAlreadyVerified:
        return LazyLocalizedStrings.emailIsAlreadyVerifiedError;
        break;
      case ServiceExceptionType.emailIsNotAllowed:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.identifierMismatch:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.imageUploadError:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.invalidAmount:
        return LazyLocalizedStrings.invalidAmountError;
        break;
      case ServiceExceptionType.invalidCredentials:
        return LazyLocalizedStrings.invalidCredentialsError;
        break;
      case ServiceExceptionType.invalidCustomerId:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.invalidEmailFormat:
        return LazyLocalizedStrings.invalidEmailFormatError;
        break;
      case ServiceExceptionType.invalidPasswordFormat:
        return LazyLocalizedStrings.invalidPasswordFormatError;
        break;
      case ServiceExceptionType.invalidPrivateAddress:
        return LazyLocalizedStrings.invalidPrivateAddressError;
        break;
      case ServiceExceptionType.invalidPublicAddress:
        return LazyLocalizedStrings.invalidPublicAddressError;
        break;
      case ServiceExceptionType.invalidReceiver:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.invalidSignature:
        return LazyLocalizedStrings.invalidSignatureError;
        break;
      case ServiceExceptionType.invalidPriceInSpendRule:
        return _getGenericError();
        break;
      case ServiceExceptionType.invalidWalletLinkSignature:
        return LazyLocalizedStrings.invalidWalletLinkSignatureError;
        break;
      case ServiceExceptionType.invalidVerticalInSpendRule:
        return _getGenericError();
        break;
      case ServiceExceptionType.linkingRequestAlreadyApproved:
        return LazyLocalizedStrings.linkingRequestAlreadyApprovedError;
        break;
      case ServiceExceptionType.linkingRequestAlreadyExists:
        return LazyLocalizedStrings.linkingRequestAlreadyExistsError;
        break;
      case ServiceExceptionType.linkingRequestDoesNotExist:
        return LazyLocalizedStrings.linkingRequestDoesNotExistError;
        break;
      case ServiceExceptionType.loginAlreadyInUse:
        return LazyLocalizedStrings.loginAlreadyInUseError;
        break;
      case ServiceExceptionType.loginAttemptsWarning:
        return exception is LoginAttemptsWarningException
            ? LazyLocalizedStrings.loginPageLoginAttemptWarningMessage(
                exception.attemptsLeft)
            : LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.noCustomerWithSuchEmail:
        return LazyLocalizedStrings.noCustomerWithSuchEmailError;
        break;
      case ServiceExceptionType.notEnoughTokens:
        return LazyLocalizedStrings.notEnoughTokensError(
            _localSettingsRepository.getMobileSettings()?.tokenSymbol);
        break;
      case ServiceExceptionType.noVouchersInStock:
        return LazyLocalizedStrings.noVouchersInStockError;
        break;
      case ServiceExceptionType.paymentDoesNotExist:
        return LazyLocalizedStrings.paymentDoesNotExistError;
        break;
      case ServiceExceptionType.paymentIsNotInACorrectStatusToBeUpdated:
        return LazyLocalizedStrings
            .paymentIsNotInACorrectStatusToBeUpdatedError;
        break;
      case ServiceExceptionType.paymentRequestsIsForAnotherCustomer:
        return LazyLocalizedStrings.paymentRequestsIsForAnotherCustomerError;
        break;
      case ServiceExceptionType.phoneAlreadyExists:
        return LazyLocalizedStrings.phoneAlreadyExistsError;
        break;
      case ServiceExceptionType.phoneIsAlreadyVerified:
        return LazyLocalizedStrings.phoneIsAlreadyVerifiedError;
        break;
      case ServiceExceptionType.providedIdentifierHasExpired:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.reachedMaximumRequestForPeriod:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.referralAlreadyConfirmed:
        return LazyLocalizedStrings.referralAlreadyConfirmedError;
        break;
      case ServiceExceptionType.referralAlreadyExist:
        return LazyLocalizedStrings.referralAlreadyExistError;
        break;
      case ServiceExceptionType.referralLeadAlreadyConfirmed:
        return LazyLocalizedStrings.referralLeadAlreadyConfirmedError;
        break;
      case ServiceExceptionType.referralLeadAlreadyExist:
        return LazyLocalizedStrings.referralLeadAlreadyExistError;
        break;
      case ServiceExceptionType.referralLeadCustomerIdInvalid:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.referralLeadNotProcessed:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.referralNotFound:
        return LazyLocalizedStrings.referralNotFoundError;
        break;
      case ServiceExceptionType.referralsLimitExceeded:
        return LazyLocalizedStrings.referralsLimitExceededError;
        break;
      case ServiceExceptionType.senderCustomerNotEnoughBalance:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.senderCustomerNotFound:
        return LazyLocalizedStrings.senderCustomerNotFoundError;
        break;
      case ServiceExceptionType.sfAccountAlreadyExisting:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.spendRuleNotFound:
        return _getGenericError();
        break;
      case ServiceExceptionType.targetCustomerNotFound:
        return LazyLocalizedStrings.targetCustomerNotFoundError;
        break;
      case ServiceExceptionType.thereIsNoIdentifierForThisCustomer:
        return LocalizedStringBuilder.custom(exceptionMessage);
        break;
      case ServiceExceptionType.tooManyLoginRequest:
        return exception is TooManyRequestException
            ? LazyLocalizedStrings.loginPageTooManyRequestMessage(
                exception.retryPeriodInMinutes)
            : LazyLocalizedStrings.tooManyLoginRequestError;
        break;
      case ServiceExceptionType.transferSourceAndTargetMustBeDifferent:
        return LazyLocalizedStrings.transferSourceAndTargetMustBeDifferentError;
        break;
      case ServiceExceptionType.transferSourceCustomerWalletBlocked:
        return LazyLocalizedStrings.transferSourceCustomerWalletBlockedError;
        break;
      case ServiceExceptionType.transferTargetCustomerWalletBlocked:
        return LazyLocalizedStrings.transferTargetCustomerWalletBlockedError;
        break;
      case ServiceExceptionType.verificationCodeDoesNotExist:
        return LazyLocalizedStrings.verificationCodeDoesNotExistError;
        break;
      case ServiceExceptionType.verificationCodeExpired:
        return LazyLocalizedStrings.verificationCodeExpiredError;
        break;
      case ServiceExceptionType.verificationCodeMismatch:
        return LazyLocalizedStrings.verificationCodeMismatchError;
        break;
      case ServiceExceptionType.pinIsNotSet:
        return LocalizedStringBuilder.custom(exceptionMessage);
      case ServiceExceptionType.pinCodeMismatch:
        return LazyLocalizedStrings.pinErrorIncorrectPassCode;
      case ServiceExceptionType.pinAlreadySet:
        return LocalizedStringBuilder.custom(exceptionMessage);
    }

    return LocalizedStringBuilder.custom(exceptionMessage);
  }
}

ExceptionToMessageMapper useExceptionToMessageMapper(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).getExceptionToMessageMapper;
