import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/di/hotel_referral_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class HotelReferralBloc extends Bloc<HotelReferralState> {
  HotelReferralBloc(
    this._referralRepository,
    this._exceptionToMessageMapper,
  );

  final ReferralRepository _referralRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  HotelReferralState initialState() => HotelReferralUninitializedState();

  Future<void> submitHotelReferral({
    @required String fullName,
    @required String email,
    @required int countryCodeId,
    @required String phoneNumber,
    @required String earnRuleId,
  }) async {
    setState(HotelReferralSubmissionLoadingState());
    try {
      await _referralRepository.submitHotelReferral(
        fullName: fullName?.trim(),
        email: email.trim(),
        countryCodeId: countryCodeId,
        phoneNumber: phoneNumber?.trim(),
        earnRuleId: earnRuleId,
      );
      sendEvent(HotelReferralSubmissionSuccessEvent());
    } on Exception catch (e) {
      setState(_getErrorFromException(e));
    }
  }

  HotelReferralSubmissionErrorState _getErrorFromException(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.referralAlreadyConfirmed:
        case ServiceExceptionType.referralsLimitExceeded:
        case ServiceExceptionType.canNotReferYourself:
        case ServiceExceptionType.referralAlreadyExist:
          return HotelReferralSubmissionErrorState(error: errorMessage);
        default:
          break;
      }
    }

    return HotelReferralSubmissionErrorState(
        error: errorMessage, canRetry: true);
  }
}

HotelReferralBloc useHotelReferralBloc() =>
    ModuleProvider.of<HotelReferralModule>(useContext()).hotelReferralBloc;
