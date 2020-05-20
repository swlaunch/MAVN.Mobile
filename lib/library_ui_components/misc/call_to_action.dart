import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class CallToAction extends StatelessWidget {
  const CallToAction({@required this.text, @required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyles.imageButtonCardCallToAction,
        ),
      );
}
