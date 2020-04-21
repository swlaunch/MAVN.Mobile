import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class CountryListState extends BaseState {}

class CountryListUninitializedState extends CountryListState {}

class CountryListLoadingState extends CountryListState with BaseLoadingState {}

class CountryListErrorState extends CountryListState {
  CountryListErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class CountryListLoadedState extends CountryListState {
  CountryListLoadedState({
    @required this.countryList,
  });

  final List<Country> countryList;
}

class UserCountrySuccessEvent extends BlocEvent {
  UserCountrySuccessEvent({this.userCountry});

  final Country userCountry;
}
