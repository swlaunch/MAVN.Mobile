import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';

class ScaffoldWithAppBar extends StatelessWidget {
  const ScaffoldWithAppBar({
    this.useDarkTheme = false,
    this.body,
    this.title,
    Key key,
  }) : super(key: key);

  final bool useDarkTheme;
  final Widget body;
  final Widget title;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:
                useDarkTheme ? ColorStyles.primaryDark : ColorStyles.white,
            brightness: useDarkTheme ? Brightness.dark : Brightness.light,
            elevation: 0,
            leading: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 8),
              child: CustomBackButton(
                  color: useDarkTheme
                      ? ColorStyles.white
                      : ColorStyles.primaryDark),
            ),
            primary: true,
            title: title ?? Container()),
        body: SafeArea(child: body ?? Container()),
      );
}
