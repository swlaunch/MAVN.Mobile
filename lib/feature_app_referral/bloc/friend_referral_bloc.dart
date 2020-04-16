import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/di/friend_referral_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class FriendReferralBloc extends Bloc<FriendReferralState> {
  FriendReferralBloc(
    this._referralRepository,
    this._exceptionToMessageMapper,
  );

  final ExceptionToMessageMapper _exceptionToMessageMapper;

  final ReferralRepository _referralRepository;

  @override
  FriendReferralState initialState() => FriendReferralUninitializedState();

  Future<void> submitFriendReferral({
    @required String fullName,
    @required String email,
    @required String earnRuleId,
  }) async {
    setState(FriendReferralSubmissionLoadingState());
    try {
      await _referralRepository.submitFriendReferral(
        fullName: fullName?.trim(),
        email: email?.trim(),
        earnRuleId: earnRuleId,
      );
      sendEvent(FriendReferralSubmissionSuccessEvent());
    } on Exception catch (e) {
      setState(_getErrorFromException(e));
    }
  }

  FriendReferralSubmissionErrorState _getErrorFromException(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.referralAlreadyConfirmed:
        case ServiceExceptionType.referralsLimitExceeded:
        case ServiceExceptionType.canNotReferYourself:
        case ServiceExceptionType.referralAlreadyExist:
          return FriendReferralSubmissionErrorState(error: errorMessage);
        default:
          break;
      }
    }

    return FriendReferralSubmissionErrorState(
        error: errorMessage, canRetry: true);
  }
}

FriendReferralBloc useFriendReferralBloc() =>
    ModuleProvider.of<FriendReferralModule>(useContext()).friendReferralBloc;
