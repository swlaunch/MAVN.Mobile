import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class ScaffoldWithScrollableContent extends StatelessWidget {
  const ScaffoldWithScrollableContent({
    @required this.heading,
    @required this.hint,
    @required this.content,
    this.bottomButton,
    Key key,
  }) : super(key: key);

  final String heading;
  final String hint;
  final Widget content;
  final PrimaryButton bottomButton;

  @override
  Widget build(BuildContext context) => ScaffoldWithAppBar(
      useDarkTheme: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Heading(heading),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Text(
                      hint,
                      style: TextStyles.darkBodyBody1RegularHigh,
                    ),
                  ),
                  content
                ],
              ),
            ),
          ),
          if (bottomButton != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
              child: bottomButton,
            )
        ],
      ));
}
