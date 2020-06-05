import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_field.dart';
import 'package:mockito/mockito.dart';

class FormHelper {
  FormHelper(this._widgetTester);

  final WidgetTester _widgetTester;

  // region when

  Future<void> whenEnteredValue({
    @required Key key,
    @required String value,
  }) async {
    await _widgetTester.enterText(
      find.byKey(key),
      value,
    );

    await _widgetTester.pumpAndSettle();
  }

  Future<void> whenSelectedValue<T>({
    @required Key key,
    @required T value,
  }) async {
    final finder = find.byKey(key);

    _widgetTester
        .widget<FullPageSelectField<T>>(finder)
        .selectedValueNotifier
        .value = value;
  }

  Future<void> whenKeyboardTextInputActionTapped(
      TextInputAction inputAction) async {
    await _widgetTester.testTextInput.receiveAction(inputAction);
    await _widgetTester.pumpAndSettle();
  }

  Future<void> whenButtonTapped(Key key) async {
    await _widgetTester.ensureVisible(find.byKey(key));
    await _widgetTester.tap(find.byKey(key));
    await _widgetTester.pumpAndSettle();
  }

  Future<void> whenTextFieldExceedsCharacterLimit({Key key, int limit}) async {
    await _widgetTester.enterText(
        find.byKey(key), _generateNumberOfCharacters(limit + 1));
    await _widgetTester.pumpAndSettle();
  }

  // endregion when

  // region then

  void thenValidationErrorIsPresent(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }

  void thenValidationErrorIsNotPresent(String errorMessage) {
    expect(find.text(errorMessage), findsNothing);
  }

  void thenValidationErrorsArePresent(List<String> errorMessages) {
    errorMessages.forEach(
        (errorMessage) => expect(find.text(errorMessage), findsOneWidget));
  }

  void thenValidationErrorsAreNotPresent(List<String> errorMessages) {
    errorMessages.forEach(
        (errorMessage) => expect(find.text(errorMessage), findsNothing));
  }

  void thenNoValidationErrorsArePresent() {
    expect(find.byType(InlineErrorWidget).evaluate().length, 0);
  }

  void thenTextFieldIsFocused({@required Key key}) =>
      _textFieldIsFocused(key, true);

  void thenTextFieldIsNotFocused({@required Key key}) =>
      _textFieldIsFocused(key, false);

  void thenSelectFieldIsFocused({@required Key key}) =>
      _selectFieldIsFocused(key, true);

  void thenSelectFieldIsNotFocused({@required Key key}) =>
      _selectFieldIsFocused(key, false);

  void thenAnalyticsEventIsSent(Function analyticsEvent) {
    verify(analyticsEvent()).called(1);
  }

  void thenTextFieldHasValue({
    @required Key key,
    @required String value,
  }) =>
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.text(value), matchRoot: true),
          findsOneWidget);

  void thenSelectFieldHasValue({
    @required Key key,
    @required String value,
  }) =>
      expect(
          find.descendant(
              of: find.byKey(key), matching: find.text(value), matchRoot: true),
          findsOneWidget);

  void thenOnlyTheMaximumCharactersArePresent({Key key, int limit}) {
    final noteTextFieldFinder = find.descendant(
      of: find.byKey(key),
      matching: find.byType(TextField),
      matchRoot: true,
    );

    expect(
        _widgetTester
            .widget<TextField>(noteTextFieldFinder)
            .controller
            .text
            .length,
        limit);
  }

  // endregion then

  // region private methods

  void _textFieldIsFocused(Key key, bool isFocused) {
    final textFieldFinder = find.byKey(key);

    expect(_widgetTester.widget<TextField>(textFieldFinder).focusNode.hasFocus,
        isFocused);
  }

  void _selectFieldIsFocused(Key key, bool isFocused) {
    final selectFieldFinder = find.byKey(key);

    expect(
        _widgetTester
            .widget<FullPageSelectField>(selectFieldFinder)
            .focusNode
            .hasFocus,
        isFocused);
  }

  String _generateNumberOfCharacters(int count) {
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      buffer.write('i');
    }
    return buffer.toString();
  }

  // endregion private
}
