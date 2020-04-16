import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/styled_input_decoration.dart';

class StyledDropDownButtonDecoration extends StyledInputDecoration {
  StyledDropDownButtonDecoration({
    @required String hintText,
    Widget suffix,
    EdgeInsets contentPadding,
  }) : super(
          labelText: hintText,
          suffix: suffix,
          contentPadding: contentPadding,
        );
}
