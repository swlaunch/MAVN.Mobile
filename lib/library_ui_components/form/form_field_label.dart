import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel(
    this.text, {
    this.hasError = false,
    this.padding = const EdgeInsets.only(bottom: 8),
  });

  final String text;
  final bool hasError;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        padding: padding,
        child: Text(text.toUpperCase(),
            style: hasError
                ? TextStyles.inputLabelBoldError
                : TextStyles.darkInputLabelBold),
      );
}
