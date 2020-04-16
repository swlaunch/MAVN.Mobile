import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/styled_outline_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class ResultFeedbackPage extends StatelessWidget {
  const ResultFeedbackPage({
    @required this.widgetKey,
    @required this.title,
    @required this.details,
    @required this.buttonText,
    @required this.onButtonTap,
    this.subDetails,
    this.detailsStyle = TextStyles.darkBodyBody1Bold,
    this.subDetailsStyle = TextStyles.darkBodyBody2RegularHigh,
    this.startIcon,
    this.endIcon,
    this.isLoading = false,
    this.hasBackButton = true,
    this.hasLogo = false,
    this.resultFeedbackButtonStyle = ResultFeedbackButtonStyle.primary,
  });

  final Key widgetKey;
  final String title;
  final String details;
  final String subDetails;
  final TextStyle detailsStyle;
  final TextStyle subDetailsStyle;
  final String startIcon;
  final String endIcon;
  final String buttonText;
  final Function onButtonTap;
  final bool isLoading;
  final bool hasBackButton;
  final bool hasLogo;
  final ResultFeedbackButtonStyle resultFeedbackButtonStyle;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          primary: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: hasBackButton ? const CustomBackButton() : null,
          backgroundColor: ColorStyles.white,
          title: hasLogo ? SvgPicture.asset(SvgAssets.appDarkLogo) : null,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                key: widgetKey,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Heading(
                        title,
                        icon: startIcon,
                        rowAlignment: CrossAxisAlignment.start,
                        endContent:
                            endIcon == null ? null : StandardSizedSvg(endIcon),
                      ),
                      const SizedBox(height: 24),
                      if (isLoading)
                        const Center(
                          child: Spinner(
                              key: Key('formSuccessErrorWidgetSpinner')),
                        ),
                      if (!isLoading) Text(details, style: detailsStyle),
                      const SizedBox(height: 24),
                      if (subDetails != null)
                        Text(subDetails, style: subDetailsStyle),
                      const Spacer(),
                      if (resultFeedbackButtonStyle ==
                          ResultFeedbackButtonStyle.primary)
                        PrimaryButton(
                          buttonKey: const Key('formSuccessErrorButton'),
                          onTap: onButtonTap,
                          text: buttonText,
                        ),
                      if (resultFeedbackButtonStyle ==
                          ResultFeedbackButtonStyle.styled)
                        StyledOutlineButton(
                          key: const Key('formSuccessErrorButton'),
                          useDarkTheme: true,
                          onTap: onButtonTap,
                          text: buttonText,
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

enum ResultFeedbackButtonStyle { primary, styled }
