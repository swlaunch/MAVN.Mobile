import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/sim_info/sim_card_info_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/country/country_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc_output.dart';

class CountryCodeListBloc extends Bloc<CountryCodeListState> {
  CountryCodeListBloc(
    this._countryRepository,
    this._simCardInfoManager,
    this._exceptionToMessageMapper,
  );

  final CountryRepository _countryRepository;
  final SimCardInfoManager _simCardInfoManager;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  CountryCodeListState initialState() => CountryCodeListUninitializedState();

  Future<void> loadCountryCodeList() async {
    setState(CountryCodeListLoadingState());

    try {
      final countryCodeListResponse =
          await _countryRepository.getCountryCodeList();

      setState(CountryCodeListLoadedState(
        countryCodeList: countryCodeListResponse.countryCodeList,
      ));

      sendEvent(CountryCodeListLoadedEvent(
        countryCodeList: countryCodeListResponse.countryCodeList,
      ));
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);

      setState(CountryCodeListErrorState(errorMessage));
    }
  }

  Future<void> getCountryCodeFromSim(List<CountryCode> countryCodeList) async {
    try {
      final userIso2Code = await _simCardInfoManager.getIso2Code();
      final userCountryCode = countryCodeList.firstWhere(
          (country) =>
              country.countryIso2Code.toLowerCase() ==
              userIso2Code.toLowerCase(),
          orElse: () => null);

      if (userCountryCode != null) {
        sendEvent(
            UserSimCountryCodeSuccessEvent(userCountryCode: userCountryCode));
      }
    } catch (_) {
      // on iOS if the phone doesn't have a SIM card, the simCardInfoManager
      // will throw, but we can ignore the error and just not set a default
    }
  }
}

CountryCodeListBloc useCountryCodeListBloc() =>
    ModuleProvider.of<AppModule>(useContext()).countryCodeListBloc;
