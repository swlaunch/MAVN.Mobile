import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/focus_state_hook.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/read_only_text_field.dart';

typedef String _DisplayValueSelector<T>(T selectedValue);
typedef Future<T> _RouterFn<T>(Router router);

class FullPageSelectField<T> extends HookWidget with FormMixin {
  const FullPageSelectField({
    @required this.selectedValueNotifier,
    @required this.displayValueSelector,
    @required this.routerFn,
    key,
    this.label,
    this.hint,
    this.inputGlobalKey,
    this.contextGlobalKey,
    this.fieldValidationManager,
    this.focusNode,
    this.nextFocusNode,
    this.showErrorText = true,
  }) : super(key: key);

  final ValueNotifier<T> selectedValueNotifier;
  final _DisplayValueSelector<T> displayValueSelector;
  final _RouterFn<T> routerFn;
  final String label;
  final String hint;
  final FieldValidationManager fieldValidationManager;
  final GlobalKey<FormFieldState<T>> inputGlobalKey;
  final GlobalKey contextGlobalKey;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    useFocusState(
      context: context,
      focusNode: focusNode,
    );

    final onValueUpdated = useMemoized(() => () {
          inputGlobalKey.currentState.didChange(selectedValueNotifier.value);
          inputGlobalKey.currentState.validate();
        });

    useListenable(selectedValueNotifier)
      ..removeListener(onValueUpdated)
      ..addListener(onValueUpdated);

    final hasValue = selectedValueNotifier.value != null &&
        displayValueSelector(selectedValueNotifier.value) != null;

    final textEditingController = useCustomTextEditingController(
        text: hasValue
            ? displayValueSelector(selectedValueNotifier.value)
            : hint);

    return Builder(
        key: contextGlobalKey,
        builder: (context) => FormField<T>(
              key: inputGlobalKey,
              validator: (value) =>
                  fieldValidationManager?.validator(value)?.localize(context),
              initialValue: selectedValueNotifier.value,
              builder: (state) => Column(
                children: [
                  if (label != null)
                    FormFieldLabel(label, hasError: state.hasError),
                  InkWell(
                    key: const Key('fullPageSelectFieldButton'),
                    onTap: () {
                      _navigateToListPage(
                        context,
                        state,
                        textEditingController,
                        router,
                      );
                    },
                    child: ReadOnlyTextField(
                      valueKey: const Key('fullPageSelectReadOnlyTextField'),
                      textEditingController: textEditingController,
                      hasError: state.hasError,
                      fadedText: false,
                      useHintFont: !hasValue,
                      focusNode: focusNode,
                      suffix: SvgPicture.asset(
                        SvgAssets.dropdown,
                        alignment: Alignment.bottomCenter,
                        height: 16,
                        color: state.hasError
                            ? ColorStyles.errorRed
                            : ColorStyles.primaryDark,
                      ),
                    ),
                  ),
                  if (showErrorText && state.hasError)
                    InlineErrorWidget(
                      errorMessage: state.errorText,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 8),
                    )
                ],
              ),
            ));
  }

  Future<void> _navigateToListPage(
    BuildContext context,
    FormFieldState<T> state,
    TextEditingController textEditingController,
    Router router,
  ) async {
    dismissKeyboard(context);

    final result = await routerFn(router);

    if (result != null && result is T) {
      selectedValueNotifier.value = result;
      textEditingController.text =
          result != null ? displayValueSelector(result) : null;

      if (nextFocusNode != null) {
        FocusScope.of(context).requestFocus(nextFocusNode);
        return;
      } else {
        focusNode?.unfocus();
      }
    } else {
      if (selectedValueNotifier.value == null && focusNode != null) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    }
  }
}
