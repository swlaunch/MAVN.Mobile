import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SmsAutoFillWidget extends HookWidget {
  // ignore: prefer_const_constructors_in_immutables
  SmsAutoFillWidget({
    this.verificationCodeValueNotifier,
    this.isErrorDismissed,
    this.verifyOnTap,
    this.codeFocusNode,
    Key key,
  }) : super(key: key);

  static const double _gapSpace = 40;

  final ValueNotifier<String> verificationCodeValueNotifier;
  final ValueNotifier<bool> isErrorDismissed;
  final VoidCallback verifyOnTap;

  final FocusNode codeFocusNode;
  final _errorUnderlineDecoration = const UnderlineDecoration(
      textStyle: TextStyles.inputTextBoldError,
      color: ColorStyles.errorRed,
      gapSpace: _gapSpace);

  final _focusedUnderlineDecoration = const UnderlineDecoration(
      textStyle: TextStyles.darkBodyBody1Bold,
      color: ColorStyles.primaryBlue,
      gapSpace: _gapSpace);

  final _underlineDecoration = const UnderlineDecoration(
      textStyle: TextStyles.darkBodyBody1Bold,
      color: ColorStyles.paleLilac,
      gapSpace: _gapSpace);

  @override
  Widget build(BuildContext context) {
    final verificationBloc = usePhoneNumberVerificationBloc();
    final verificationState =
        useBlocState<PhoneNumberVerificationState>(verificationBloc);

    useEffect(() {
      // ignore: lines_longer_than_80_chars
      //TODO after this goes to QA, check with them if this point of listening is early enough or the SMS is sent before we start listening
      SmsAutoFill().listenForCode;
    }, [key]);

    final hasFocus = useState<bool>(codeFocusNode.hasFocus);

    final onFocusChanged = useMemoized(
        () => () {
              hasFocus.value = codeFocusNode.hasFocus;
              if (!isErrorDismissed.value &&
                  hasFocus.value &&
                  verificationState is PhoneNumberVerificationErrorState) {
                isErrorDismissed.value = true;
                verificationCodeValueNotifier.value = null;
              }
            },
        [verificationState]);

    useListenable(codeFocusNode)
      ..removeListener(onFocusChanged)
      ..addListener(onFocusChanged);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: <Widget>[
          PinFieldAutoFill(
            currentCode: verificationCodeValueNotifier.value,
            focusNode: codeFocusNode,
            codeLength: PhoneNumberVerificationBloc.codeLength,
            keyboardType: TextInputType.number,
            onCodeChanged: (newCode) {
              verificationCodeValueNotifier.value = newCode;
            },
            onCodeSubmitted: (_) => verifyOnTap(),
            decoration: _getDecoration(
                verificationState is PhoneNumberVerificationErrorState &&
                    !isErrorDismissed.value,
                hasFocus),
          ),
          if (verificationState is PhoneNumberVerificationErrorState &&
              !isErrorDismissed.value)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InlineErrorWidget(
                errorMessage: verificationState.errorMessage,
              ),
            )
        ],
      ),
    );
  }

  UnderlineDecoration _getDecoration(
      bool hasError, ValueNotifier<bool> hasFocus) {
    if (hasError) {
      return _errorUnderlineDecoration;
    } else if (hasFocus.value != null && hasFocus.value) {
      return _focusedUnderlineDecoration;
    } else {
      return _underlineDecoration;
    }
  }
}
