import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';

FieldValidationManager<T> useFieldValidationManager<T>(
  List<FieldValidation<T>> fieldValidationList, {
  LocalizedStringBuilder multipleErrorsMessage,
  BuildValidationMessageFunction<T> buildMessage,
}) =>
    Hook.use(_FieldValidationManagerHook<T>(
      fieldValidationList,
      multipleErrorsMessage: multipleErrorsMessage,
      buildMessage: buildMessage,
    ));

class _FieldValidationManagerHook<T> extends Hook<FieldValidationManager<T>> {
  const _FieldValidationManagerHook(
    this.fieldValidationList, {
    this.multipleErrorsMessage,
    this.buildMessage,
  });

  final List<FieldValidation<T>> fieldValidationList;
  final LocalizedStringBuilder multipleErrorsMessage;
  final BuildValidationMessageFunction<T> buildMessage;

  @override
  _FieldValidationManagerHookState<T> createState() =>
      _FieldValidationManagerHookState<T>();
}

class _FieldValidationManagerHookState<T> extends HookState<
    FieldValidationManager<T>, _FieldValidationManagerHook<T>> {
  FieldValidationManager<T> _fieldValidationManager;

  @override
  void initHook() => _fieldValidationManager = FieldValidationManager<T>(
        hook.fieldValidationList,
        multipleErrorsMessage: hook.multipleErrorsMessage,
        buildMessage: hook.buildMessage,
      );

  @override
  FieldValidationManager<T> build(BuildContext context) =>
      _fieldValidationManager;

  @override
  void dispose() => _fieldValidationManager.dispose();
}
