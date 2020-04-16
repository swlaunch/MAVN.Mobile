import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

// Reset app state before every scenario
class ResetAppStateHook extends Hook {
  @override
  Future<void> onAfterScenarioWorldCreated(
      World world, String scenario, Iterable<Tag> tags) async {
    if (world is FlutterWithMockServerWorld) {
      await world.driver.requestData('resetAppState');
    }
  }

  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    // Wait for the initial loading of the app
    await Future.delayed(const Duration(seconds: 3));
  }
}
