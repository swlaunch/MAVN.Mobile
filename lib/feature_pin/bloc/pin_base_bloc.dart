import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PinBlocBase extends Bloc<PinState> {
  PinBlocBase(this.digitsLimit);

  final List<int> digits = [];

  bool _isHidden = true;

  bool get isHidden => _isHidden;

  final int digitsLimit;

  @override
  PinState initialState() => PinEmptyState();

  Future<void> addDigit(int digit) async {
    if (digits.length >= digitsLimit) {
      return;
    }

    digits.add(digit);

    setState(PinFilledState(
      digits: digits,
      isHidden: _isHidden,
      isSubmitVisible: isSubmitVisible,
    ));

    await onPassCodeChange();
  }

  Future<void> removeFromPassCode() async {
    if (digits.isEmpty) {
      return;
    }

    digits.removeLast();

    digits.isEmpty
        ? setState(PinEmptyState())
        : setState(PinFilledState(
            digits: digits,
            isHidden: _isHidden,
            isSubmitVisible: isSubmitVisible,
          ));

    await onPassCodeChange();
  }

  Future<void> onPassCodeChange() {}

  Future<void> toggleHidden() async {
    _isHidden = !_isHidden;

    setState(PinFilledState(
      digits: digits,
      isHidden: _isHidden,
      isSubmitVisible: isSubmitVisible,
    ));

    await onPassCodeChange();
  }

  bool get isSubmitVisible;
}
