import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_base_bloc.dart';

Future<void> addDigitsToPinBloc(PinBlocBase bloc, int digit, int count) async {
  for (var i = 0; i < count; i++) {
    await bloc.addDigit(digit);
  }
}
