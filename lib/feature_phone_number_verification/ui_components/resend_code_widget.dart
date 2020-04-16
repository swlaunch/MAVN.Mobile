import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class ResendCodeWidget extends HookWidget {
  const ResendCodeWidget({this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final phoneVerificationGenerationBloc =
        usePhoneVerificationGenerationBloc();
    final phoneVerificationGenerationState =
        useBlocState<PhoneVerificationGenerationState>(
            phoneVerificationGenerationBloc);
    final tickerBloc = useTickerBloc();
    final tickerBlocState = useBlocState<TickerState>(tickerBloc);
    final getMobileSettingsUseCase = useGetMobileSettingsUseCase(context);

    void startTicker() {
      final expirationPeriod = getMobileSettingsUseCase
          .execute()
          ?.registrationMobileSettings
          ?.verificationCodeExpirationPeriod;
      tickerBloc.startTicker(durationInSeconds: expirationPeriod?.inSeconds);
    }

    useEffect(() {
      startTicker();
    }, [tickerBloc]);

    useBlocEventListener(phoneVerificationGenerationBloc, (event) {
      if (event is PhoneVerificationGenerationSentSmsEvent) {
        startTicker();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: _buildPhoneVerificationGenerationState(
              phoneVerificationGenerationState),
        ),
        _buildTickerState(tickerBlocState),
      ],
    );
  }

  Widget _buildPhoneVerificationGenerationState(
      PhoneVerificationGenerationState phoneVerificationGenerationState) {
    if (phoneVerificationGenerationState
        is PhoneVerificationGenerationSuccessState) {
      return _getPhoneVerificationGenerationContent(
        asset: SvgAssets.success,
        text: LocalizedStrings.phoneNumberVerificationCodeResent,
      );
    } else if (phoneVerificationGenerationState
        is PhoneVerificationGenerationErrorState) {
      return _getPhoneVerificationGenerationContent(
        asset: SvgAssets.error,
        text: phoneVerificationGenerationState.errorMessage,
      );
    } else if (phoneVerificationGenerationState
        is PhoneVerificationGenerationLoadingState) {
      return const Center(child: Spinner());
    }
    return Container();
  }

  Widget _getPhoneVerificationGenerationContent({String asset, String text}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 40),
          StandardSizedSvg(asset),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyles.darkBodyBody2Regular,
          )
        ],
      );

  Widget _buildTickerState(TickerState tickerState) => Column(
        children: <Widget>[
          const SizedBox(height: 8),
          if (tickerState is TickerTickingState)
            Text(
              LocalizedStrings.phoneNumberVerificationResendCodeTimer(
                  tickerState.displayTime),
              style: TextStyles.darkBodyBody3Regular,
            ),
          if (tickerState is TickerFinishedState)
            FlatButton(
              padding: const EdgeInsets.all(0),
              onPressed: onTap,
              child: Text(
                LocalizedStrings.phoneNumberVerificationRequestNewCode,
                style: TextStyles.linksTextLinkBold,
              ),
            )
        ],
      );
}
