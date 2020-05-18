import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';
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
              LocalizedStrings.accountPagePersonalDetailsOption,
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
                  title: LocalizedStrings.somethingIsNotRightError,
                  text: LocalizedStrings.personalDetailsGenericError,
                  icon: SvgAssets.genericError,
                  errorKey: const Key('personalDetailsError'),
                  onRetryTap: getCustomerInfo,
                ),
              ),
            if (personalDetailsBlocState is PersonalDetailsLoadedState)
              Expanded(
                  child: _buildBody(personalDetailsBlocState.customer, router)),
          ],
        ),
      ),
    );
  }
}

Widget _buildBody(CustomerResponseModel customer, Router router) {
  final list = _getListItems(customer);
  return Column(
    children: <Widget>[
      Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 32),
          key: const Key('personalDetailsView'),
          itemBuilder: (context, position) => list[position].build(),
          itemCount: list.length,
        ),
      ),
      _buildDeleteButton(onTap: router.showDeleteAccountDialog),
    ],
  );
}

Widget _buildDeleteButton({@required VoidCallback onTap}) => PrimaryButton(
    text: LocalizedStrings.personalDetailsDeleteAccountButton, onTap: onTap);

class _PersonalDetailItem {
  _PersonalDetailItem(this.title, this.value);

  final String title;
  final String value;

  Widget build() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NullSafeText(title.toUpperCase(),
              style: TextStyles.darkInputLabelBold),
          const SizedBox(height: 8),
          NullSafeText(value, style: TextStyles.darkInputTextBold),
          const SizedBox(height: 24),
        ],
      );
}

List _getListItems(CustomerResponseModel customer) => [
      _PersonalDetailItem(
          LocalizedStrings.personalDetailsFirstNameTitle, customer.firstName),
      _PersonalDetailItem(
          LocalizedStrings.personalDetailsLastNameTitle, customer.lastName),
      _PersonalDetailItem(
          LocalizedStrings.personalDetailsEmailTitle, customer.email),
      _PersonalDetailItem(LocalizedStrings.personalDetailsPhoneNumberTitle,
          customer.phoneNumber),
      if (!StringUtils.isNullOrEmpty(customer.countryOfNationalityName))
        _PersonalDetailItem(
          LocalizedStrings.personalDetailsCountryOfNationality,
          customer.countryOfNationalityName,
        ),
    ];
