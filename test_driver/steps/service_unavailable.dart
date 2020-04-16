import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

class GivenServiceUnavailable
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.mockServer.shutdown();
  }

  @override
  RegExp get pattern => RegExp(r'the service is unavailable');
}
