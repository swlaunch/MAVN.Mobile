import 'package:flutter/widgets.dart';

class TextHighlighter extends StatelessWidget {
  const TextHighlighter({
    @required this.text,
    @required this.textToHighlight,
    @required this.textStyle,
    @required this.highlightedTextStyle,
  });

  final String text;
  final String textToHighlight;
  final TextStyle textStyle;
  final TextStyle highlightedTextStyle;
  @override
  Widget build(BuildContext context) {
    if (textToHighlight == null || textToHighlight.isEmpty) {
      return Text(
        text,
        style: textStyle,
      );
    }

    var highlightedText = '';
    var textAfter = '';

    final textCharacters = text.split('');

    const highlightStartIndex = 0;
    final highlightEndIndex = highlightStartIndex + textToHighlight.length;

    highlightedText =
        textCharacters.sublist(highlightStartIndex, highlightEndIndex).join();
    textAfter = textCharacters.sublist(highlightEndIndex).join();

    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(text: highlightedText, style: highlightedTextStyle),
          TextSpan(text: textAfter, style: textStyle),
        ],
      ),
    );
  }
}
