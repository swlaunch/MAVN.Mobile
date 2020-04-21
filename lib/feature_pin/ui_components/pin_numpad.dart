import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/num_pad.dart';

class PinNumPad extends StatelessWidget {
  const PinNumPad({
    @required this.headingText,
    @required this.description,
    @required this.maxPinLength,
    @required this.pinState,
    @required this.toggleHidden,
    @required this.addNumber,
    @required this.removeLastNumber,
    @required this.onSubmitTap,
    this.isFooterVisible = true,
    this.footer,
    this.forgotButton,
    Key key,
  }) : super(key: key);

  PinNumPad.withSubmitButton({
    @required this.headingText,
    @required this.description,
    @required this.maxPinLength,
    @required this.pinState,
    @required this.toggleHidden,
    @required this.addNumber,
    @required this.removeLastNumber,
    @required this.onSubmitTap,
    @required this.isFooterVisible,
    @required String submitButtonText,
    this.forgotButton,
  }) : footer = PrimaryButton(
          buttonKey: const Key('pinSubmitButton'),
          text: submitButtonText,
          onTap: onSubmitTap,
          isLoading: pinState is PinLoadingState,
        );

  final String headingText;
  final String description;
  final int maxPinLength;
  final PinState pinState;
  final VoidCallback toggleHidden;
  final Function(int) addNumber;
  final VoidCallback removeLastNumber;
  final VoidCallback onSubmitTap;
  final bool isFooterVisible;
  final Widget footer;
  final FlatButton forgotButton;

  @override
  Widget build(BuildContext context) {
    final pinState = this.pinState;
    final isPinHidden = (pinState is PinFilledState) ? pinState.isHidden : true;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Heading(headingText),
          const SizedBox(height: 8),
          Text(description, style: TextStyles.darkBodyBody2RegularHigh),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildPinDots(maxPinLength, pinState, isPinHidden),
              ),
            ),
          ),
          _buildErrorMessage(context, pinState),
          _buildShowHideButton(pinState, isPinHidden, context),
          Expanded(
            flex: 8,
            child: NumPad(
              onNumberPress: addNumber,
              onDeletePress: removeLastNumber,
              isDeleteButtonVisible: !(pinState is PinEmptyState),
              bottomLeftButton: forgotButton,
            ),
          ),
          const SizedBox(height: 8),
          _buildFooter()
        ],
      ),
    );
  }

  List<Widget> _buildPinDots(
      int maxPinLength, PinState state, bool isPinHidden) {
    final filledNumbers = (state is PinFilledState) ? state.digits : [];

    return List.generate(
        maxPinLength,
        (index) => PinNumber(
              data: index >= filledNumbers.length ? null : filledNumbers[index],
              isHidden: isPinHidden,
            ));
  }

  Widget _buildShowHideButton(
      PinState pinState, bool isPinHidden, BuildContext context) {
    if (!(pinState is PinEmptyState)) {
      return FlatButton(
        onPressed: toggleHidden,
        child: Text(
          isPinHidden
              ? LocalizedStrings.of(context).pinShow
              : LocalizedStrings.of(context).pinHide,
          style: TextStyles.linksTextLinkBold,
        ),
      );
    }
    if (pinState is PinEmptyState) {
      return SizedBox(height: ButtonTheme.of(context).height + 12);
    }

    return const SizedBox();
  }

  Widget _buildErrorMessage(BuildContext context, PinState pinState) => Text(
        pinState is PinErrorState
            ? pinState.error.localize(context)
            : '',
        style: TextStyles.errorTextBold,
        textAlign: TextAlign.center,
      );

  Widget _buildFooter() {
    if (footer != null && isFooterVisible) {
      return footer;
    }

    return const SizedBox(height: 48);
  }
}

class PinNumber extends StatelessWidget {
  const PinNumber({
    @required this.data,
    @required this.isHidden,
    Key key,
  }) : super(key: key);

  final int data;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    if (isHidden || data == null) {
      return Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            color:
                data != null ? ColorStyles.charcoalGrey : ColorStyles.paleLilac,
            shape: BoxShape.circle),
      );
    }

    return Text(
      data.toString(),
      style: TextStyles.darkHeadersH2,
    );
  }
}
