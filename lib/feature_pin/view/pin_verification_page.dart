import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_sign_in_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/ui_components/pin_numpad.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';

class PinVerificationPage extends HookWidget {
  const PinVerificationPage();

  @override
  Widget build(BuildContext context) {
    final pinBloc = usePinSignInBloc();
    final pinState = useBlocState<PinState>(pinBloc);

    final router = useRouter();
    final passCode = pinState is PinFilledState ? pinState.digits : [];

    useBlocEventListener(pinBloc, (event) {
      if (event is PinSignInEvent) {
        router.pop(true);
        return;
      }

      if (event is PinReachedMaximumAttemptsEvent) {
        useLogOutUseCase(context: context).execute();
        router.navigateToLoginPage();
      }
    });

    return ScaffoldWithLogo(
      hasBackButton: true,
      body: PinNumPad(
        headingText: useLocalizedStrings().pinSignInHeading,
        description: useLocalizedStrings().pinVerificationDescription,
        addNumber: pinBloc.addDigit,
        maxPinLength: pinBloc.digitsLimit,
        pinState: pinState,
        toggleHidden: pinBloc.toggleHidden,
        removeLastNumber: pinBloc.removeFromPassCode,
        onSubmitTap: () {
          router.pushPinConfirmPage(passCode);
        },
      ),
    );
  }
}
