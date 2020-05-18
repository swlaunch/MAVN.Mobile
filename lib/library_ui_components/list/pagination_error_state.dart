import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class PaginationErrorWidget extends StatelessWidget {
  const PaginationErrorWidget({
    @required this.errorText,
    @required this.onRetry,
    Key key,
  }) : super(key: key);

  final String errorText;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  errorText,
                  style: TextStyles.darkBodyBody2RegularHigh,
                ),
              ),
              const SizedBox(width: 24),
              SvgPicture.asset(
                SvgAssets.genericError,
                color: ColorStyles.errorRed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            child: Text(
              LocalizedStrings.of(context).retryButton.toUpperCase(),
              style: TextStyles.linksTextLinkBold,
            ),
            onTap: () {
              onRetry();
            },
          )
        ],
      );
}
