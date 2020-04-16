import 'package:flutter_html/rich_text_parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class HtmlStyles {
  static CustomTextStyle get defaultStyles => (node, baseStyle) {
        if (node is dom.Element) {
          switch (node.localName) {
            case 'h1':
              return TextStyles.darkHeadersH1;
            case 'h2':
              return TextStyles.darkHeadersH2;
          }
        }
        return TextStyles.darkBodyBody2RegularHigh;
      };
}
