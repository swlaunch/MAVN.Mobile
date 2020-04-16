import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TextEditingController useCustomTextEditingController({
  String text,
  List keys,
  bool rebuildOnChange = false,
}) =>
    Hook.use(_TextEditingControllerHook(
        text: text, keys: keys, rebuildOnChange: rebuildOnChange));

class _TextEditingControllerHook extends Hook<TextEditingController> {
  const _TextEditingControllerHook({
    this.text,
    this.rebuildOnChange,
    List keys,
  }) : super(keys: keys);

  final String text;
  final bool rebuildOnChange;

  @override
  _TextEditingControllerHookState createState() =>
      _TextEditingControllerHookState();
}

class _TextEditingControllerHookState
    extends HookState<TextEditingController, _TextEditingControllerHook> {
  TextEditingController _textEditingController;

  @override
  void didUpdateHook(_TextEditingControllerHook oldHook) {
    if (hook.text != oldHook.text) {
      _textEditingController.text = hook.text;
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  void initHook() {
    _textEditingController = TextEditingController(text: hook.text);
    if (hook.rebuildOnChange) {
      _textEditingController.addListener(_listener);
    }
  }

  @override
  TextEditingController build(BuildContext context) => _textEditingController;

  @override
  void dispose() {
    _textEditingController
      ..removeListener(_listener)
      ..dispose();
  }
}
