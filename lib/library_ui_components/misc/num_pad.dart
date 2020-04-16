import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class NumPad extends StatelessWidget {
  const NumPad({
    @required this.onNumberPress,
    @required this.onDeletePress,
    this.bottomLeftButton,
    this.isDeleteButtonVisible = false,
    Key key,
  }) : super(key: key);

  final Function(int) onNumberPress;
  final VoidCallback onDeletePress;
  final FlatButton bottomLeftButton;
  final bool isDeleteButtonVisible;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _generateButtons([1, 2, 3], onNumberPress),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _generateButtons([4, 5, 6], onNumberPress),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _generateButtons([7, 8, 9], onNumberPress),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              bottomLeftButton ?? const _NumPadButton.placeholder(),
              ..._generateButtons([0], onNumberPress),
              if (isDeleteButtonVisible)
                _NumPadButton.asset(
                  SvgAssets.arrowBack,
                  onPressed: onDeletePress,
                ),
              if (!isDeleteButtonVisible) const _NumPadButton.placeholder()
            ],
          )
        ],
      );

  List<_NumPadButton> _generateButtons(
          List<int> digits, Function(int) onPressed) =>
      digits
          .map((number) => _NumPadButton.title(number.toString(),
              onPressed: () => onPressed(number)))
          .toList();
}

class _NumPadButton extends StatelessWidget {
  const _NumPadButton({
    @required this.child,
    this.onPressed,
    Key key,
  }) : super(key: key);

  const _NumPadButton.placeholder()
      : child = const SizedBox(),
        onPressed = null;

  _NumPadButton.title(String title, {VoidCallback onPressed})
      : child = Text(
          title,
          style: TextStyles.darkBodyBody1Bold,
        ),
        onPressed = onPressed;

  _NumPadButton.asset(String assetName, {VoidCallback onPressed})
      : child = SvgPicture.asset(assetName),
        onPressed = onPressed;

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FlatButton(
        onPressed: onPressed,
        child: Container(
          width: 48,
          height: 48,
          child: Center(child: child),
        ),
        shape: const CircleBorder(),
      );
}
