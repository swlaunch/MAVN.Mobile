import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/text_highlighter.dart';

class SelectListItem2Col extends StatelessWidget {
  const SelectListItem2Col({
    @required this.startText,
    @required this.endText,
    @required this.valueKey,
    @required this.onTap,
    this.query,
  });

  final String startText;
  final String endText;
  final ValueKey valueKey;
  final VoidCallback onTap;
  final String query;

  @override
  Widget build(context) => SelectListItem(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: 12),
        valueKey: valueKey,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextHighlighter(
                text: startText,
                textToHighlight: query,
                textStyle:
                    TextStyles.darkBodyBody1RegularHigh.copyWith(height: 1.2),
                highlightedTextStyle:
                    TextStyles.darkBodyBody1Bold.copyWith(height: 1.2),
              ),
            ),
            Text(
              endText,
              style: TextStyles.darkBodyBody1Regular,
            ),
          ],
        ),
      );
}
