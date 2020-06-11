import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/initials_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/call_to_action.dart';

class VoucherTopSection extends HookWidget {
  const VoucherTopSection({@required this.partner});

  final String partner;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final router = useRouter();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 76,
                width: 76,
                child: InitialsWidget(
                  initialsText: partner,
                  color: ColorStyles.resolutionBlue,
                  textColor: ColorStyles.white,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    partner,
                    style: TextStyles.partnerNameTopSection,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  CallToAction(
                    text: localizedStrings.viewPartner,
                    onTap: router.pushComingSoonPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
