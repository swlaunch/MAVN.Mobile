import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lykke_mobile_mavn/app/resources/html_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class HotelMessage extends StatelessWidget {
  const HotelMessage({
    @required this.partnerName,
    @required this.heading,
    @required this.message,
    this.endContent,
  });

  final String partnerName;
  final String heading;
  final String message;
  final Widget endContent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(partnerName, style: TextStyles.darkBodyBody3Regular),
            const SizedBox(height: 8),
            Heading(heading),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: message,
                  style: HtmlStyles.defaultStyles,
                ),
              ),
            ),
            if (endContent != null)
              Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  endContent,
                ],
              ),
          ],
        ),
      );
}
