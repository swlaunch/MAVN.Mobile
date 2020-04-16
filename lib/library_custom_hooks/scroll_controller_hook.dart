import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useScrollController({
  List keys,
}) =>
    Hook.use(_ScrollControllerHook(keys: keys));

class _ScrollControllerHook extends Hook<ScrollController> {
  const _ScrollControllerHook({
    List keys,
  }) : super(keys: keys);

  @override
  _ScrollControllerHookState createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ScrollController, _ScrollControllerHook> {
  ScrollController _scrollController;

  void _listener() {
    setState(() {});
  }

  @override
  void initHook() {
    _scrollController = ScrollController()..addListener(_listener);
  }

  @override
  ScrollController build(BuildContext context) => _scrollController;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_listener)
      ..dispose();
  }
}
