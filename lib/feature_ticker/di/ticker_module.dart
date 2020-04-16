import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TickerModule extends Module {
  TickerBloc get tickerBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => TickerBloc());
  }
}
