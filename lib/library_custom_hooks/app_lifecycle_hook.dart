import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef AppLifecycleCallback = void Function(
    AppLifecycleState appLifecycleState);

void useAppLifecycle(AppLifecycleCallback appLifecycleCallback) =>
    Hook.use(_AppLifecycleHook(appLifecycleCallback));

class _AppLifecycleHook extends Hook<void> {
  const _AppLifecycleHook(this.appLifecycleCallback);

  final AppLifecycleCallback appLifecycleCallback;

  @override
  _AppLifecycleHookState createState() => _AppLifecycleHookState();
}

class _AppLifecycleHookState extends HookState<void, _AppLifecycleHook>
    with WidgetsBindingObserver {
  @override
  void initHook() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (hook.appLifecycleCallback != null) {
      hook.appLifecycleCallback(state);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
