import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/ui_components/instalment_item.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class InstalmentListPage extends HookWidget {
  const InstalmentListPage(
    this.spendRuleId,
    this.property,
  );

  final String spendRuleId;
  final Property property;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final instalmentListBloc = useInstalmentListBloc();
    final instalmentListState = useBlocState(instalmentListBloc);

    useEffect(() {
      instalmentListBloc.mapInstalments(property.instalments);
    }, [instalmentListBloc]);

    void onInstalmentTap(ExtendedInstalmentModel extendedInstalment) {
      router.pushPropertyPaymentPage(
        spendRuleId: spendRuleId,
        property: property,
        extendedInstalment: extendedInstalment,
      );
    }

    return ScaffoldWithAppBar(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Heading(property.name),
                  const SizedBox(height: 32),
                  Text(
                    useLocalizedStrings().instalmentListChooseAnInstalment,
                    style: TextStyles.darkHeadersH3,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (instalmentListState is InstalmentListLoadedState)
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: instalmentListState.extendedInstalments.length,
                  itemBuilder: (context, position) => InstalmentItem(
                    extendedInstalment:
                        instalmentListState.extendedInstalments[position],
                    onTap: onInstalmentTap,
                  ),
                  separatorBuilder: (context, position) => StandardDivider(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
