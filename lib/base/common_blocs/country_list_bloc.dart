import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/sim_info/sim_card_info_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/country/country_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc_output.dart';

class CountryListBloc extends Bloc<CountryListState> {
  CountryListBloc(
    this._countryRepository,
    this._simCardInfoManager,
    this._exceptionToMessageMapper,
  );

  final CountryRepository _countryRepository;
  final SimCardInfoManager _simCardInfoManager;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  CountryListState initialState() => CountryListUninitializedState();

  Future<void> loadCountryList() async {
    setState(CountryListLoadingState());

    try {
      final countryListResponse = await _countryRepository.getCountryList();

      setState(CountryListLoadedState(
        countryList: countryListResponse.countryList,
      ));

      try {
        final userIso2Code = await _simCardInfoManager.getIso2Code();
        final userCountry = countryListResponse.countryList.firstWhere(
            (country) =>
                country.countryIso2Code.toLowerCase() ==
                userIso2Code.toLowerCase(),
            orElse: () => null);
        if (userCountry != null) {
          sendEvent(UserCountrySuccessEvent(userCountry: userCountry));
        }
      } catch (_) {
        // on iOS if the phone doesn't have a SIM card, the simCardInfoManager
        // will throw, but we can ignore the error and just not set a default
      }
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);

      setState(CountryListErrorState(errorMessage));
    }
  }
}

CountryListBloc useCountryListBloc() =>
    ModuleProvider.of<AppModule>(useContext()).countryListBloc;
