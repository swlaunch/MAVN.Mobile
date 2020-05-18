import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

abstract class BaseOfferUnavailableWidget {
  BaseOfferUnavailableWidget({
    this.title,
    this.buttonText,
    this.onButtonTap,
    this.bodyBuilder,
  });

  final LocalizedStringBuilder title;
  final LocalizedStringBuilder buttonText;
  final VoidCallback onButtonTap;
  final WidgetBuilder bodyBuilder;

  Widget build(BuildContext context) => Container(
        color: ColorStyles.white,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: ColorStyles.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.black15,
                blurRadius: 20,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const StandardSizedSvg(
                    SvgAssets.genericError,
                    color: ColorStyles.errorRed,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title.localize(context).toUpperCase(),
                      style: TextStyles.darkInputLabelBold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              bodyBuilder(context),
              const SizedBox(height: 16),
              FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: onButtonTap,
                child: Text(
                  buttonText.localize(context),
                  style: TextStyles.linksTextLinkBold,
                ),
              )
            ],
          ),
        ),
      );
}

class WalletDisabledWidget extends BaseOfferUnavailableWidget {
  WalletDisabledWidget({this.router})
      : super(
          title: LazyLocalizedStrings.walletPageWalletDisabledError,
          buttonText: LazyLocalizedStrings.contactUsButton,
          onButtonTap: router.pushContactUsPage,
          bodyBuilder: (context) => Text(
            LocalizedStrings.of(context).walletPageWalletDisabledErrorMessage,
            style: TextStyles.darkBodyBody1RegularHigh,
          ),
        );

  final Router router;
}
