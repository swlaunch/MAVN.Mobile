import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

class ThenTextIsPresent
    extends Then1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    expect(
      await FlutterDriverUtils.isPresent(world.driver, find.text(input)),
      true,
    );
  }

  @override
  RegExp get pattern => RegExp(r'I expect the text {String} to be present');
}
