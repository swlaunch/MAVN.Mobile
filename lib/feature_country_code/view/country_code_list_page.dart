import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_list.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item_2_col.dart';

class CountryCodeListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final countryCodeListBloc = useCountryCodeListBloc();
    final countryCodeListBlocState = useBlocState(countryCodeListBloc);
    final router = useRouter();

    useEffect(() {
      countryCodeListBloc.loadCountryCodeList();
    }, [countryCodeListBloc]);

    return FullPageSelectList<CountryCode>(
      headingBuilder: (heading) => SelectListHeading(heading),
      itemBuilder: (countryCode, query) => SelectListItem2Col(
        startText: countryCode.name,
        endText: countryCode.code,
        valueKey: Key('countryCodeListItem_${countryCode.id}'),
        onTap: () {
          router.pop(countryCode);
        },
        query: query,
      ),
      displayValueSelector: (countryCode) => countryCode.name,
      pageTitle: useLocalizedStrings().countryCodeListPageTitle,
      valueKey: const Key('countryCodeList'),
      isLoading: countryCodeListBlocState is CountryCodeListLoadingState,
      list: countryCodeListBlocState is CountryCodeListLoadedState
          ? countryCodeListBlocState.countryCodeList
          : null,
      errorText: countryCodeListBlocState is CountryCodeListErrorState
          ? countryCodeListBlocState.error.localize(useContext())
          : null,
      onRetry: () {
        countryCodeListBloc.loadCountryCodeList();
      },
      groupAlphabetically: true,
      showFilter: true,
      filterHintText: useLocalizedStrings().countryListFilterHint,
    );
  }
}
