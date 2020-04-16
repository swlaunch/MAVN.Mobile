import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/di/lead_referral_di.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'lead_referral_bloc_output.dart';

export 'lead_referral_bloc_output.dart';

class LeadReferralBloc extends Bloc<LeadReferralState> {
  LeadReferralBloc(
    this._referralRepository,
    this._exceptionToMessageMapper,
  );

  final ReferralRepository _referralRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LeadReferralState initialState() => LeadReferralUninitializedState();

  Future<void> submitLeadReferral({
    @required String firstName,
    @required String lastName,
    @required CountryCode countryCode,
    @required String phone,
    @required String email,
    @required String note,
    @required String earnRuleId,
  }) async {
    setState(LeadReferralSubmissionLoadingState());
    try {
      await _referralRepository.submitLeadReferral(
        firstName: firstName?.trim(),
        lastName: lastName?.trim(),
        countryCodeId: countryCode.id,
        phone: phone?.trim(),
        email: email?.trim(),
        note: note,
        earnRuleId: earnRuleId,
      );
      sendEvent(LeadReferralSubmissionSuccessEvent());
    } on Exception catch (e) {
      setState(getErrorFromException(e));
    }
  }

  LeadReferralSubmissionErrorState getErrorFromException(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is NetworkException) {
      return LeadReferralSubmissionErrorState(
          error: errorMessage, canRetry: true);
    }

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.referralLeadAlreadyExist:
        case ServiceExceptionType.canNotReferYourself:
        case ServiceExceptionType.referralLeadAlreadyConfirmed:
          return LeadReferralSubmissionErrorState(
              error: errorMessage, canRetry: false);
        default:
          return LeadReferralSubmissionErrorState(
              error: errorMessage, canRetry: true);
      }
    }

    return LeadReferralSubmissionErrorState(
        error: errorMessage, canRetry: true);
  }
}

LeadReferralBloc useLeadReferralBloc() =>
    ModuleProvider.of<LeadReferralModule>(useContext()).leadReferralBloc;
