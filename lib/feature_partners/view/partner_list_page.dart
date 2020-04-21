import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class PartnerListPage extends StatelessWidget {
  const PartnerListPage({
    this.partners,
  });

  final List<Partner> partners;

  @override
  Widget build(BuildContext context) {
    final itemViewList =
        partners.map((partner) => _PartnerDetailItem(partner)).toList();

    return ScaffoldWithAppBar(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child:
                Heading(LocalizedStrings.of(context).partnerDetailsPageTitle),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 32),
              key: const Key('partnerListView'),
              shrinkWrap: true,
              itemBuilder: (context, position) =>
                  itemViewList[position].build(),
              itemCount: partners.length,
              separatorBuilder: (context, position) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StandardDivider(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerDetailItem {
  _PartnerDetailItem(this.partner);

  final Partner partner;

  Widget build() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Text(partner.name.toUpperCase(),
            style: TextStyles.darkInputLabelBold),
      );
}
