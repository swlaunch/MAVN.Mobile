import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenIAmOnThePage extends Given1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input) async {
    final locator = find.byType(input);

    expect(
        await FlutterDriverUtils.isPresent(
          world.driver,
          locator,
          timeout: const Duration(seconds: 3),
        ),
        true);
  }

  @override
  RegExp get pattern => RegExp(r'I am on the page {string}');
}
