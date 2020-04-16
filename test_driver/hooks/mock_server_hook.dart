import 'package:gherkin/gherkin.dart';
import 'package:mock_web_server/mock_web_server.dart';

import '../helpers/mock_server_dispatcher.dart';
import '../worlds/flutter_with_mock_server_world.dart';

class MockServerHook extends Hook {
  MockServerHook() {
    mockServer.dispatcher = mockServerDispatcher.dispatcher;
  }

  final mockServer = MockWebServer(port: 9876);
  final mockServerDispatcher = MockServerDispatcher();

  @override
  int get priority => 10;

  @override
  Future<void> onAfterScenarioWorldCreated(
      World world, String scenario, Iterable<Tag> tags) async {
    if (world is FlutterWithMockServerWorld) {
      world
        ..mockServer = mockServer
        ..mockServerDispatcher = mockServerDispatcher;
    }
  }

  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario, Iterable<Tag> tags) async {
    try {
      // GivenServiceUnavailable step could close our mock server so,
      // restart mockServer if it is not already started

      // This will crash if server is not started already
      mockServer.url;
    } catch (_) {
      await mockServer.start();
    }
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) => mockServer.shutdown();
}
