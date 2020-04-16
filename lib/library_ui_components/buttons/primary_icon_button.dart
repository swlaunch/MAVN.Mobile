import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    @required this.text,
    @required this.onTap,
    @required this.asset,
    this.buttonKey,
  }) : super();

  final VoidCallback onTap;
  final String text;
  final Key buttonKey;
  final String asset;

  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        child: RaisedButton(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          key: buttonKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(asset),
              Expanded(
                child: AutoSizeText(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyles.darkBodyBody2Bold,
                ),
              )
            ],
          ),
          onPressed: onTap,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      );
}
