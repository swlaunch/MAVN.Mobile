import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/ui_components/small_token_icon.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class InstalmentItem extends StatelessWidget {
  const InstalmentItem({
    @required this.extendedInstalment,
    this.onTap,
  });

  final ExtendedInstalmentModel extendedInstalment;

  final Function(ExtendedInstalmentModel) onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap(extendedInstalment),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      extendedInstalment.instalment.name,
                      style: TextStyles.darkBodyBody2RegularHigh,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const StandardSizedSvg(SvgAssets.arrow),
                ],
              ),
              _buildDetails(context)
            ],
          ),
        ),
      );

  Widget _buildDetails(BuildContext context) => RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody4Regular,
          children: [
            WidgetSpan(
              child: SmallTokenIcon(),
              alignment: PlaceholderAlignment.bottom,
            ),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: extendedInstalment.instalment.amountInTokens.value),
            const TextSpan(text: ' • '),
            TextSpan(text: extendedInstalment.formattedDate),
            if (extendedInstalment.isOverdue) ..._buildOverdueText(context),
          ],
        ),
      );

  List<TextSpan> _buildOverdueText(BuildContext context) => [
        const TextSpan(text: ' • '),
        TextSpan(
          text: LocalizedStrings.of(context).installmentOverdue,
          style: TextStyles.bodyBody4RegularError,
        ),
      ];
}
