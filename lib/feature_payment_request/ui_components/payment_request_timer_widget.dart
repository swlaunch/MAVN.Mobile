import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/ui_components/payment_request_info_line.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class PaymentRequestTimerWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tickerBloc = useTickerBloc();
    final tickerBlocState = useBlocState<TickerState>(tickerBloc);
    return PaymentRequestInfoLine(
      pairKey: useLocalizedStrings().transferRequestRemainingTimeLabel,
      pairValue: tickerBlocState is TickerTickingState
          ? tickerBlocState.displayTime.localize(useContext())
          : '',
    );
  }
}
