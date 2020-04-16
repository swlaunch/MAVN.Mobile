import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef void OnDispose();

void useOnDispose(OnDispose onDisposeCallback) =>
    Hook.use(_OnDisposeHook(onDisposeCallback));

class _OnDisposeHook extends Hook<void> {
  const _OnDisposeHook(this.onDisposeCallback);

  final OnDispose onDisposeCallback;

  @override
  _OnDisposeHookState createState() => _OnDisposeHookState();
}

class _OnDisposeHookState extends HookState<void, _OnDisposeHook> {
  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    if (hook.onDisposeCallback != null) {
      hook.onDisposeCallback();
    }
    super.dispose();
  }
}
