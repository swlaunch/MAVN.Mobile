import 'package:flutter/services.dart';

///Replaces all decimal separators different from
///[_standardSeparator] with [_standardSeparator]
class DelimiterTextInputFormatter extends TextInputFormatter {
  static const _standardSeparator = '.';
  static const _commaSeparator = ',';
  static const _arabicSeparator = '\u066B';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var truncated = newValue.text;
    final newSelection = newValue.selection;

    if (newValue.text.contains(_commaSeparator)) {
      truncated =
          newValue.text.replaceFirst(_commaSeparator, _standardSeparator);
    } else if (newValue.text.contains(_arabicSeparator)) {
      truncated =
          newValue.text.replaceFirst(_arabicSeparator, _standardSeparator);
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}
