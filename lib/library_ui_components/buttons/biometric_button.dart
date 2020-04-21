import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class BiometricButton extends HookWidget {
  const BiometricButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final biometricTypeBloc = useBiometricTypeBloc();
    final biometricTypeState =
        useBlocState<BiometricTypeState>(biometricTypeBloc);

    useEffect(() {
      biometricTypeBloc.checkType();
    }, [biometricTypeBloc]);

    return biometricTypeState is BiometricTypeLoadedState
        ? Padding(
            padding: const EdgeInsets.only(left: 4),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(biometricTypeState.assetName),
                  const SizedBox(width: 16),
                  Text(
                    biometricTypeState.label.localize(useContext()),
                    style: TextStyles.linksTextLinkBoldHigh,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
