import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_confirm_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/ui_components/pin_numpad.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/loading_overlay_mixin.dart';

class PinConfirmPage extends HookWidget with LoadingOverlayMixin {
  PinConfirmPage(this.passCode);

  final List<int> passCode;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final pinBloc = usePinConfirmBloc()..initialDigits = passCode;
    final pinState = useBlocState<PinState>(pinBloc);
    final isSubmitVisible =
        pinState is PinFilledState ? pinState.isSubmitVisible : false;

    useBlocEventListener(pinBloc, (event) {
      if (event is PinStoredEvent) {
        router.pushRootPinCreatedSuccessPage();
      }

      if (event is PinLoadingEvent) {
        showLoadingOverlay(context);
      }

      if (event is PinLoadedEvent) {
        hideLoadingOverlay(context);
      }
    });

    return ScaffoldWithLogo(
        hasBackButton: true,
        body: PinNumPad.withSubmitButton(
          headingText: useLocalizedStrings().pinConfirmHeading,
          description: useLocalizedStrings().pinConfirmDescription,
          addNumber: pinBloc.addDigit,
          maxPinLength: pinBloc.digitsLimit,
          pinState: pinState,
          toggleHidden: pinBloc.toggleHidden,
          removeLastNumber: pinBloc.removeFromPassCode,
          onSubmitTap: pinBloc.storePin,
          isFooterVisible: isSubmitVisible,
          submitButtonText: useLocalizedStrings().submitButton,
        ));
  }
}
