import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'accept_lead_referral_bloc_output.dart';

class AcceptLeadReferralBloc extends Bloc<AcceptLeadReferralState> {
  AcceptLeadReferralBloc(
    this._referralRepository,
    this._localSettingsRepository,
    this._exceptionToMessageMapper,
  );

  final ReferralRepository _referralRepository;
  final LocalSettingsRepository _localSettingsRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  AcceptLeadReferralState initialState() =>
      AcceptLeadReferralUninitializedState();

  Future<void> storeReferralCode(String code) async {
    await _localSettingsRepository.storeLeadReferralCode(code);
    sendEvent(LeadReferralSubmissionStoredKey());
  }

  bool hasPendingReferralConfirmation() =>
      _localSettingsRepository.getLeadReferralCode() != null;

  Future<void> acceptPendingReferral() async {
    setState(AcceptLeadReferralLoadingState());

    final referralCode = _localSettingsRepository.getLeadReferralCode();

    if (referralCode == null) {
      setState(AcceptLeadReferralErrorState(
          error: LazyLocalizedStrings.referralAcceptedInvalidCode));
      return;
    }

    try {
      await _referralRepository.leadReferralConfirm(code: referralCode);

      await _localSettingsRepository.removeLeadReferralCode();

      setState(AcceptLeadReferralSuccessState());
    } on Exception catch (e) {
      setState(AcceptLeadReferralErrorState(
          error: _exceptionToMessageMapper.map(e)));
    }
  }
}

AcceptLeadReferralBloc useAcceptLeadReferralBloc() =>
    ModuleProvider.of<AppModule>(useContext()).acceptLeadReferralBloc;
