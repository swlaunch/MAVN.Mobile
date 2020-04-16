import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/text_highlighter.dart';

class SelectListItem1Col extends StatelessWidget {
  const SelectListItem1Col({
    @required this.text,
    @required this.valueKey,
    @required this.onTap,
    this.query,
  });

  final String text;
  final ValueKey valueKey;
  final VoidCallback onTap;
  final String query;

  @override
  Widget build(context) => SelectListItem(
        onTap: onTap,
        valueKey: valueKey,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: TextHighlighter(
          text: text,
          textToHighlight: query,
          textStyle: TextStyles.darkBodyBody1RegularHigh.copyWith(height: 1.2),
          highlightedTextStyle:
              TextStyles.darkBodyBody1Bold.copyWith(height: 1.2),
        ),
      );
}
