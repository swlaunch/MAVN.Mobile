import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class RadioButton extends StatelessWidget {
  const RadioButton({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.title,
  });

  final dynamic value;
  final dynamic groupValue;
  final Function(dynamic val) onChanged;
  final String title;

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          //the unselected color of Radio
          unselectedWidgetColor: ColorStyles.cloudyBlue,
          //bottom 2 to remove splash from InkWell
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: InkWell(
          onTap: () => onChanged(value),
          child: Container(
            //offsetting the default Radio padding
            transform: Matrix4.translationValues(-8, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Radio(
                  activeColor: ColorStyles.primaryBlue,
                  groupValue: groupValue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: onChanged,
                  value: value,
                ),
                Text(title, style: TextStyles.darkBodyBody4Regular),
              ],
            ),
          ),
        ),
      );
}
