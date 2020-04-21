import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class PersonalDetailsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final personalDetailsBloc = usePersonalDetailsBloc();
    final personalDetailsBlocState = useBlocState(personalDetailsBloc);
    final router = useRouter();

    void getCustomerInfo() {
      personalDetailsBloc.getCustomerInfo();
    }

    useEffect(() {
      getCustomerInfo();
    }, [personalDetailsBloc]);

    return ScaffoldWithAppBar(
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Heading(
              useLocalizedStrings().accountPagePersonalDetailsOption,
              icon: SvgAssets.personalDetails,
            ),
            if (personalDetailsBlocState is PersonalDetailsLoadingState)
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Spinner(key: Key('personalDetailsPageSpinner')),
                ),
              ),
            if (personalDetailsBlocState is PersonalDetailsNetworkErrorState)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: NetworkErrorWidget(onRetry: getCustomerInfo),
              ),
            if (personalDetailsBlocState is PersonalDetailsGenericErrorState)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: GenericErrorIconWidget(
                  title: useLocalizedStrings().somethingIsNotRightError,
                  text: useLocalizedStrings().personalDetailsGenericError,
                  icon: SvgAssets.genericError,
                  errorKey: const Key('personalDetailsError'),
                  onRetryTap: getCustomerInfo,
                ),
              ),
            if (personalDetailsBlocState is PersonalDetailsLoadedState)
              Expanded(
                  child: _buildBody(
                      context, personalDetailsBlocState.customer, router)),
          ],
        ),
      ),
    );
  }
}

Widget _buildBody(
    BuildContext context, CustomerResponseModel customer, Router router) {
  final list = _getListItems(customer);
  return Column(
    children: <Widget>[
      Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 32),
          key: const Key('personalDetailsView'),
          itemBuilder: (context, position) => list[position].build(context),
          itemCount: list.length,
        ),
      ),
      _buildDeleteButton(
          onTap: () =>
              router.showDeleteAccountDialog(LocalizedStrings.of(context))),
    ],
  );
}

Widget _buildDeleteButton({@required VoidCallback onTap}) => PrimaryButton(
    text: useLocalizedStrings().personalDetailsDeleteAccountButton,
    onTap: onTap);

class _PersonalDetailItem {
  _PersonalDetailItem(this.title, this.value);

  final LocalizedStringBuilder title;
  final String value;

  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title.localize(context).toUpperCase(),
              style: TextStyles.darkInputLabelBold),
          const SizedBox(height: 8),
          Text(value, style: TextStyles.darkInputTextBold),
          const SizedBox(height: 24),
        ],
      );
}

List<_PersonalDetailItem> _getListItems(CustomerResponseModel customer) => [
      _PersonalDetailItem(LazyLocalizedStrings.personalDetailsFirstNameTitle,
          customer.firstName),
      _PersonalDetailItem(
          LazyLocalizedStrings.personalDetailsLastNameTitle, customer.lastName),
      _PersonalDetailItem(
          LazyLocalizedStrings.personalDetailsEmailTitle, customer.email),
      _PersonalDetailItem(LazyLocalizedStrings.personalDetailsPhoneNumberTitle,
          customer.phoneNumber),
      if (!StringUtils.isNullOrEmpty(customer.countryOfNationalityName))
        _PersonalDetailItem(
          LazyLocalizedStrings.personalDetailsCountryOfNationality,
          customer.countryOfNationalityName,
        ),
    ];
