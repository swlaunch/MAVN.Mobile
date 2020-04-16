import 'package:lykke_mobile_mavn/library_form/field_validation.dart';

typedef BuildValidationMessageFunction<T> = String Function(
    List<FieldValidation<T>> failedFieldValidationList);

typedef _FieldValidationCallback<TResult> = TResult Function(
    FieldValidation fieldValidation);

class FieldValidationManager<T> {
  FieldValidationManager(
    this.fieldValidationList, {
    this.multipleErrorsMessage,
    this.buildMessage,
  });

  final List<FieldValidation<T>> fieldValidationList;
  final String multipleErrorsMessage;
  final BuildValidationMessageFunction<T> buildMessage;

  bool isValid() => fieldValidationList
      .every((fieldValidation) => fieldValidation.isValid?.value);

  String validator(T value) {
    if (multipleErrorsMessage != null) {
      return _multipleErrorsValidator(value);
    }

    if (buildMessage != null) {
      return _buildMessageValidator(value);
    }

    return _defaultValidator(value);
  }

  String _defaultValidator(T value) {
    for (final fieldValidation in fieldValidationList) {
      if (fieldValidation != null) {
        final isValid = fieldValidation.validate(value);
        fieldValidation.isValid?.value = isValid;

        if (!isValid) {
          return fieldValidation.localizedString;
        }
      }
    }
    return null;
  }

  String _multipleErrorsValidator(T value) {
    final failedValidationList = fieldValidationList
        .map((fieldVal) {
          final isValid = fieldVal.validate(value);
          fieldVal.isValid.value = isValid;
          return fieldVal;
        })
        .where((result) => !result.isValid.value)
        .toList();

    if (failedValidationList.length == 1) {
      return failedValidationList[0].localizedString;
    }
    if (failedValidationList.length > 1) {
      return multipleErrorsMessage;
    }
    return null;
  }

  String _buildMessageValidator(T value) {
    final failedFieldValidationList = fieldValidationList
        .map((fieldVal) {
          final isValid = fieldVal.validate(value);
          fieldVal.isValid.value = isValid;
          return fieldVal;
        })
        .where((result) => !result.isValid.value)
        .toList();

    return buildMessage(failedFieldValidationList);
  }

  bool validate(T value) => validator(value) == null;

  void notifyValidationErrors() {
    _forEachError((fieldValidation) => fieldValidation.onValidationError());
  }

  List<String> getErrorMessages() =>
      _mapEachError((fieldValidation) => fieldValidation.localizedString);

  String getFirstErrorMessage() {
    final firstError = _getFirstError();
    if (firstError != null) {
      return firstError.localizedString;
    }

    return null;
  }

  void _forEachError(_FieldValidationCallback callback) {
    fieldValidationList.forEach((fieldValidation) {
      if (fieldValidation.isValid?.value == false &&
          fieldValidation.onValidationError != null) {
        callback(fieldValidation);
      }
    });
  }

  Iterable<TResult> _mapEachError<TResult>(
          _FieldValidationCallback<TResult> callback) =>
      fieldValidationList.map<TResult>(
        (fieldValidation) {
          if (fieldValidation.isValid?.value == false &&
              fieldValidation.onValidationError != null) {
            return callback(fieldValidation);
          }
        },
      );

  FieldValidation _getFirstError() {
    for (final fieldValidation in fieldValidationList) {
      if (fieldValidation.isValid?.value == false &&
          fieldValidation.onValidationError != null) {
        return fieldValidation;
      }
    }
    return null;
  }

  void dispose() => fieldValidationList.forEach((fieldValidation) {
        fieldValidation.dispose();
      });
}
