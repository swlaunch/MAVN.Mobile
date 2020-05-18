import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'accept_hotel_referral_bloc_output.dart';

class AcceptHotelReferralBloc extends Bloc<AcceptHotelReferralState> {
  AcceptHotelReferralBloc(
    this._referralRepository,
    this._localSettingsRepository,
    this._exceptionToMessageMapper,
  );

  final ReferralRepository _referralRepository;
  final LocalSettingsRepository _localSettingsRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  AcceptHotelReferralState initialState() =>
      AcceptHotelReferralUninitializedState();

  Future<void> storeReferralCode(String code) async {
    await _localSettingsRepository.storeHotelReferralCode(code);
    sendEvent(HotelReferralSubmissionStoredKey());
  }

  bool hasPendingReferralConfirmation() =>
      _localSettingsRepository.getHotelReferralCode() != null;

  Future<void> acceptPendingReferral() async {
    setState(AcceptHotelReferralLoadingState());

    final referralCode = _localSettingsRepository.getHotelReferralCode();

    if (referralCode == null) {
      setState(AcceptHotelReferralErrorState(
          error: LazyLocalizedStrings.referralAcceptedInvalidCode));
      return;
    }

    try {
      await _referralRepository.hotelReferralConfirm(code: referralCode);

      await _localSettingsRepository.removeHotelReferralCode();

      setState(AcceptHotelReferralSuccessState());
    } on Exception catch (e) {
      setState(AcceptHotelReferralErrorState(
          error: _exceptionToMessageMapper.map(e)));
    }
  }
}

AcceptHotelReferralBloc useAcceptHotelReferralBloc() =>
    ModuleProvider.of<AppModule>(useContext()).acceptHotelReferralBloc;
