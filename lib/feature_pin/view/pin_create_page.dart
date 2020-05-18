import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_create_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/ui_components/pin_numpad.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/loading_overlay_mixin.dart';

class PinCreatePage extends HookWidget with LoadingOverlayMixin {
  @override
  Widget build(BuildContext context) {
    final pinBloc = usePinCreateBloc();
    final pinState = useBlocState<PinState>(pinBloc);
    final isSubmitVisible =
        pinState is PinFilledState ? pinState.isSubmitVisible : false;
    final router = useRouter();
    final passCode = pinState is PinFilledState ? pinState.digits : [];

    return ScaffoldWithLogo(
        body: PinNumPad.withSubmitButton(
      headingText: useLocalizedStrings().pinCreateHeading,
      description:
          useLocalizedStrings().pinCreateDescription(Configuration.appName),
      addNumber: pinBloc.addDigit,
      maxPinLength: pinBloc.digitsLimit,
      pinState: pinState,
      toggleHidden: pinBloc.toggleHidden,
      removeLastNumber: pinBloc.removeFromPassCode,
      onSubmitTap: () {
        router.pushPinConfirmPage(passCode);
      },
      isFooterVisible: isSubmitVisible,
      submitButtonText: useLocalizedStrings().submitButton,
    ));
  }
}
