import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_list.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item_1_col.dart';

class CountryListPage extends HookWidget {
  const CountryListPage({this.pageTitle});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final countryListBloc = useCountryListBloc();
    final countryListBlocState = useBlocState(countryListBloc);
    final router = useRouter();

    useEffect(() {
      countryListBloc.loadCountryList();
    }, [countryListBloc]);

    return FullPageSelectList<Country>(
      headingBuilder: (heading) => SelectListHeading(heading),
      itemBuilder: (country, query) => SelectListItem1Col(
        text: country.name,
        valueKey: Key('countryListItem_${country.id}'),
        onTap: () {
          router.pop(country);
        },
        query: query,
      ),
      displayValueSelector: (country) => country.name,
      pageTitle: pageTitle ?? useLocalizedStrings().countryListPageTitle,
      valueKey: const Key('countryList'),
      isLoading: countryListBlocState is CountryListLoadingState,
      list: countryListBlocState is CountryListLoadedState
          ? countryListBlocState.countryList
          : null,
      errorText: countryListBlocState is CountryListErrorState
          ? countryListBlocState.error.localize(useContext())
          : null,
      onRetry: () {
        countryListBloc.loadCountryList();
      },
      groupAlphabetically: true,
      showFilter: true,
      filterHintText: useLocalizedStrings().countryListFilterHint,
    );
  }
}
