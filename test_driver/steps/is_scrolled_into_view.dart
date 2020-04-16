import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenWidgetIsScrolledIntoView
    extends Given1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input) async {
    await world.driver.scrollIntoView(find.byValueKey(input));
  }

  @override
  RegExp get pattern => RegExp(r'{string} is scrolled into view');
}
