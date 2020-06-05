import 'package:flutter_html/style.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class HtmlStyles {
  static Map<String, Style> get defaultStyles => {
        'html': Style.fromTextStyle(TextStyles.darkBodyBody2RegularHigh),
        'h1': Style.fromTextStyle(TextStyles.darkHeadersH1),
        'h2': Style.fromTextStyle(TextStyles.darkHeadersH2),
      };
}
