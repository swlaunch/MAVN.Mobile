import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:mock_web_server/mock_web_server.dart';

import '../helpers/mock_server_dispatcher.dart';

class FlutterWithMockServerWorld extends FlutterWorld {
  MockServerDispatcher mockServerDispatcher;
  MockWebServer mockServer;

  void enqueueMockResponseFromFileForUriPath({
    String uriPath,
    String filePath,
    String method = 'get',
    int statusCode = 200,
    bool willTimeout = false,
  }) {
    mockServerDispatcher?.enqueuedResponses[uriPath] = {
      method.toLowerCase(): MockResponseFromFile(
        filePath: filePath,
        responseStatusCode: statusCode,
        willTimeout: willTimeout,
      )
    };
  }
}
