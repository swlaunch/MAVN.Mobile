import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/styled_input_decoration.dart';

class ReadOnlyTextField extends HookWidget {
  const ReadOnlyTextField({
    this.label,
    this.valueKey,
    this.textEditingController,
    this.hasError = false,
    this.fadedText = true,
    this.useHintFont = false,
    this.suffix,
    this.focusNode,
    this.nextFocusNode,
  });

  final String label;
  final Key valueKey;
  final TextEditingController textEditingController;
  final bool hasError;
  final bool fadedText;
  final bool useHintFont;
  final Widget suffix;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          if (label != null) FormFieldLabel(label),
          AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[focusNode]),
              builder: (context, _) => TextField(
                    key: valueKey,
                    enabled: false,
                    controller: textEditingController,
                    style: _getTextStyle(),
                    decoration: StyledInputDecoration(
                      hasError: hasError,
                      hasFocus: focusNode != null && focusNode.hasFocus,
                      suffix: suffix,
                    ),
                  ))
        ],
      );

  TextStyle _getTextStyle() {
    if (hasError) {
      if (useHintFont) {
        return TextStyles.inputTextRegularError;
      }

      return TextStyles.inputTextBoldError;
    }

    if (useHintFont) {
      if (fadedText) {
        return TextStyles.darkBodyBody2RegularHigh
            .copyWith(color: ColorStyles.slateGrey);
      }

      return TextStyles.darkBodyBody2RegularHigh;
    }

    if (fadedText) {
      return TextStyles.darkInputTextBold
          .copyWith(color: ColorStyles.slateGrey);
    }

    return TextStyles.darkInputTextBold;
  }
}
