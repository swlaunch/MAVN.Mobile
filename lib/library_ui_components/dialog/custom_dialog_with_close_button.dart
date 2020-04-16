import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/page_close_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class CustomDialogWithCloseButton extends StatelessWidget {
  const CustomDialogWithCloseButton({
    @required this.child,
    this.isLoading = false,
  });

  final Widget child;
  final bool isLoading;

  Widget _buildContent() {
    if (isLoading) {
      return Container(
        alignment: Alignment.center,
        child: const Spinner(color: ColorStyles.primaryBlue),
        padding: const EdgeInsets.only(bottom: 48),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: <Widget>[
            PageCloseButton(
              onTap: Navigator.of(context).pop,
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      );
}
