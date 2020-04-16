import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useFocusState({
  @required BuildContext context,
  @required FocusNode focusNode,
}) {
  final onFocusChangedCallback = useMemoized(
      () => () {
            if (focusNode != null && focusNode.hasFocus) {
              Future.microtask(() {
                Scrollable.ensureVisible(context,
                    duration: const Duration(milliseconds: 200));
              });
            }
          },
      [context]);

  if (MediaQuery.of(context).viewInsets.bottom > 0) {
    onFocusChangedCallback();
  }

  if (focusNode != null) {
    focusNode
      ..removeListener(onFocusChangedCallback)
      ..addListener(onFocusChangedCallback);
  }
}
