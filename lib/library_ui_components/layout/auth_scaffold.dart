import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    @required this.body,
    this.scaffoldKey,
    this.hasBackButton = false,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) => DismissKeyboardOnTap(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: ColorStyles.white,
          appBar: AppBar(
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              backgroundColor: ColorStyles.white,
              centerTitle: hasBackButton,
              elevation: 0,
              leading: hasBackButton
                  ? Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 8),
                      child: const CustomBackButton())
                  : null,
              primary: true,
              titleSpacing: hasBackButton ? 0.0 : 24.0,
              title: SvgPicture.asset(SvgAssets.appDarkLogo)),
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: SafeArea(child: body),
        ),
      );
}
