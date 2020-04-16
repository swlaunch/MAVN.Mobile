import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class InitialsWidget extends StatelessWidget {
  const InitialsWidget({@required this.initialsText});

  final String initialsText;

  @override
  Widget build(BuildContext context) {
    final initials = StringUtils.isNullOrWhitespace(initialsText)
        ? ''
        : initialsText.split(' ').map((s) => s.substring(0, 1)).join();
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          initials,
          style: TextStyles.darkBodyBody3Bold,
        ),
      ),
    );
  }
}
