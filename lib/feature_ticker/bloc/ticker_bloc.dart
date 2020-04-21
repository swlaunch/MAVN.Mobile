import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_ticker/bloc/ticker_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_ticker/di/ticker_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';

class TickerBloc extends Bloc<TickerState> {
  static const int _defaultDuration = 60;
  static const int _increment = 1;
  static const int _secondsInMinute = 60;
  static const int _hoursInADay = 24;

  CountdownTimer _timer;
  final compositeSubscription = CompositeSubscription();

  @override
  TickerState initialState() => TickerUninitializedState();

  Future<void> startTicker({int durationInSeconds = _defaultDuration}) async {
    if (currentState is TickerTickingState) return;
    _timer = CountdownTimer(
      Duration(seconds: durationInSeconds),
      const Duration(seconds: _increment),
    );

    final timerSubscription = _timer.listen(null);
    timerSubscription
      ..onData((duration) {
        final seconds = durationInSeconds - duration.elapsed.inSeconds;

        final remainingDuration = Duration(seconds: seconds);
        final _formattedDuration = _formatDuration(remainingDuration);
        if (currentState is! TickerTickingState ||
            (currentState as TickerTickingState).displayTime !=
                _formattedDuration) {
          setState(TickerTickingState(displayTime: _formattedDuration));
        }
      })
      ..onDone(() {
        timerSubscription.cancel();
        setState(TickerFinishedState());
        sendEvent(TickerFinishedEvent());
      });

    compositeSubscription.add(timerSubscription);
  }

  void cancelTicker() {
    _timer?.cancel();
  }

  LocalizedStringBuilder _formatDuration(Duration duration) {
    if (duration.inMinutes < _secondsInMinute) {
      return LocalizedStringBuilder.custom(_formatMinutes(duration));
    } else if (duration.inHours > 0 && duration.inHours < _hoursInADay) {
      return LazyLocalizedStrings.hours(duration.inHours);
    } else if (duration.inHours >= _hoursInADay) {
      return LazyLocalizedStrings.expirationFormatDays(duration.inDays);
    }
  }

  /// Formats Duration to the following criteria:
  /// -if hours==0 show only minutes and seconds
  /// -if hours>0, show all
  /// -all time unit strings must contain at least two characters
  String _formatMinutes(Duration duration) {
    String format(int timeUnits) =>
        timeUnits < 10 ? '0$timeUnits' : '$timeUnits';

    final durationInHours = duration.inHours;
    final String hours = durationInHours > 0 ? format(durationInHours) : null;
    final String twoDigitMinutes = format(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = format(duration.inSeconds.remainder(60));
    return StringUtils.concatenate([hours, twoDigitMinutes, twoDigitSeconds],
        separator: ':');
  }

  @override
  void dispose() {
    cancelTicker();
    compositeSubscription.dispose();
    super.dispose();
  }
}

TickerBloc useTickerBloc() =>
    ModuleProvider.of<TickerModule>(useContext()).tickerBloc;
