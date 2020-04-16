import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/timer_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/di/email_verification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

const int duration = 5;

class TimerBloc extends Bloc<TimerState> {
  Timer _timer;

  @override
  TimerState initialState() => TimerUninitializedState();

  Future<void> startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: duration), (timer) {
      sendEvent(TimerFinishedEvent());
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}

TimerBloc useTimerBloc() =>
    ModuleProvider.of<EmailVerificationModule>(useContext()).timerBloc;
