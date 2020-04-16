import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';

class ScaffoldWithLogo extends StatelessWidget {
  const ScaffoldWithLogo({this.body, this.hasBackButton = false, Key key})
      : super(key: key);

  final Widget body;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorStyles.white,
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0,
            leading: hasBackButton
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 8),
                    child: const CustomBackButton())
                : null,
            primary: true,
            title: SvgPicture.asset(SvgAssets.appDarkLogo)),
        body: SafeArea(child: body),
      );
}
