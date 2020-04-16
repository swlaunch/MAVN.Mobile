import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
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
    this.body,
  });

  final String title;
  final String buttonText;
  final VoidCallback onButtonTap;
  final Widget body;

  Widget build() => Container(
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
                      title.toUpperCase(),
                      style: TextStyles.darkInputLabelBold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              body,
              const SizedBox(height: 16),
              FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: onButtonTap,
                child: Text(
                  buttonText,
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
          title: LocalizedStrings.walletPageWalletDisabledError,
          buttonText: LocalizedStrings.contactUsButton,
          onButtonTap: router.pushContactUsPage,
          body: Text(
            LocalizedStrings.walletPageWalletDisabledErrorMessage,
            style: TextStyles.darkBodyBody1RegularHigh,
          ),
        );

  final Router router;
}
