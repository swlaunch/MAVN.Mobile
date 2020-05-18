import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class CountryCodeListState extends BaseState {}

class CountryCodeListUninitializedState extends CountryCodeListState {}

class CountryCodeListLoadingState extends CountryCodeListState
    with BaseLoadingState {}

class CountryCodeListErrorState extends CountryCodeListState {
  CountryCodeListErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class CountryCodeListLoadedState extends CountryCodeListState {
  CountryCodeListLoadedState({@required this.countryCodeList});

  final List<CountryCode> countryCodeList;
}

class CountryCodeListLoadedEvent extends BlocEvent {
  CountryCodeListLoadedEvent({@required this.countryCodeList});

  final List<CountryCode> countryCodeList;
}

class UserSimCountryCodeSuccessEvent extends BlocEvent {
  UserSimCountryCodeSuccessEvent({@required this.userCountryCode});

  final CountryCode userCountryCode;
}
