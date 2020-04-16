import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';

class DismissKeyboardOnTap extends HookWidget with FormMixin {
  const DismissKeyboardOnTap({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: child,
      );
}
