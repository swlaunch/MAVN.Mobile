import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:throttling/throttling.dart';

Throttling useThrottling({Duration duration}) =>
    Hook.use(_ThrottlingHook(duration));

class _ThrottlingHook extends Hook<Throttling> {
  const _ThrottlingHook(this.duration);

  final Duration duration;

  @override
  _ThrottlingHookState createState() => _ThrottlingHookState();
}

class _ThrottlingHookState extends HookState<Throttling, _ThrottlingHook> {
  Throttling _throttling;

  @override
  void initHook() {
    super.initHook();
    _throttling = Throttling(duration: hook.duration);
  }

  @override
  Throttling build(context) => _throttling;

  @override
  void dispose() {
    _throttling.dispose();
    super.dispose();
  }
}
