import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Expects the element found with the given control key to have the given
/// multiline value.
///
/// Parameters:
///   1 - {string} the control key
///   2 - {string} the multiline value of the control
///
/// Examples:
///
///   'Then I expect "controlKey" to be'
///   '''
///   Hello
///   World
///   '''
class ThenExpectElementToHaveMultilineValue
    extends Then2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r'I expect the {string} to be multiline');

  @override
  Future<void> executeStep(String key, String value) async {
    final text =
        await FlutterDriverUtils.getText(world.driver, find.byValueKey(key));
    expect(text, value);
  }
}
