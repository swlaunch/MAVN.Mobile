import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_sign_in_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/ui_components/pin_numpad.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/biometric_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/loading_overlay_mixin.dart';

class PinSignInPage extends HookWidget with LoadingOverlayMixin {
  @override
  Widget build(BuildContext context) {
    final pinBloc = usePinSignInBloc();
    final pinState = useBlocState<PinState>(pinBloc);
    final biometricBloc = useBiometricBloc();

    final isSubmitVisible =
        pinState is PinFilledState ? pinState.isSubmitVisible : true;
    final router = useRouter();
    final passCode = pinState is PinFilledState ? pinState.digits : [];

    useBlocEventListener(pinBloc, (event) {
      if (event is PinSignInEvent) {
        router.navigateToLandingPage();
      }

      if (event is PinReachedMaximumAttemptsEvent) {
        router.navigateToLoginPage();
      }

      if (event is PinLoadingEvent) {
        showLoadingOverlay(context);
      }

      if (event is PinLoadedEvent) {
        hideLoadingOverlay(context);
      }
    });

    useBlocEventListener(biometricBloc, (event) {
      if (event is BiometricAuthenticationSuccessEvent) {
        router.navigateToLandingPage();
      }

      if (event is BiometricAuthenticationDisabledEvent) {
        router.showEnableBiometricsDialog(useLocalizedStrings());
      }
    });

    return ScaffoldWithLogo(
      body: PinNumPad(
        headingText: useLocalizedStrings().pinSignInHeading,
        description: useLocalizedStrings().pinSignInDescription,
        addNumber: pinBloc.addDigit,
        maxPinLength: pinBloc.digitsLimit,
        pinState: pinState,
        toggleHidden: pinBloc.toggleHidden,
        removeLastNumber: pinBloc.removeFromPassCode,
        onSubmitTap: () {
          router.pushPinConfirmPage(passCode);
        },
        isFooterVisible: isSubmitVisible,
        footer: BiometricButton(
          onTap:
              biometricBloc.tryUsingBiometricAuthenticationWithAgreedPermission,
        ),
        forgotButton: _buildForgotButton(router),
      ),
    );
  }

  FlatButton _buildForgotButton(Router router) => FlatButton(
        onPressed: router.pushPinForgotPage,
        child: Text(
          useLocalizedStrings().pinForgotButton,
          style: TextStyles.darkBodyBody2Bold,
        ),
      );
}
