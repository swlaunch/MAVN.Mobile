import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

class PartnerInfoWidget extends StatelessWidget {
  const PartnerInfoWidget({@required this.onTap, @required this.partners});

  final VoidCallback onTap;
  final List<Partner> partners;

  @override
  Widget build(BuildContext context) {
    if (ListUtils.isNullOrEmpty(partners)) {
      return Container();
    }

    String partnerTitle;
    if (partners.length == 1) {
      partnerTitle = partners[0].name;
    } else {
      partnerTitle = LocalizedStrings.of(context).multiplePartnersTitle(
          partners[0].name, partners.length - 1);
    }
    return GestureDetector(
      key: const Key('partnerInfoView'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            partnerTitle,
            style: TextStyles.darkBodyBody2RegularHigh,
          ),
          if (partners.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                LocalizedStrings.of(context).viewPartnerDetailsButtonTitle,
                style: TextStyles.linksTextLinkSmallBold,
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
