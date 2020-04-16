import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:mock_web_server/mock_web_server.dart';

import 'file.dart';

Future<void> mockServerHttpClientTest(
  String groupName,
  bool Function(MockServerHttpClient) body,
) async {
  MockWebServer mockWebServer;

  mockWebServer = MockWebServer();
  await mockWebServer?.start();

  group(groupName, () {
    tearDownAll(() {
      mockWebServer?.shutdown();
    });

    body(MockServerHttpClient(mockWebServer));
  });
}

class MockServerHttpClient extends HttpClient {
  MockServerHttpClient(this.mockWebServer) : super(mockWebServer.url) {
    assert(mockWebServer != null, 'mockWebServer should not be null');
  }

  final MockWebServer mockWebServer;

  void mockResponseFromFile(String fileName, {int statusCode}) {
    mockWebServer.enqueue(
        body: getStringFromFile(fileName),
        httpCode: statusCode ?? 200,
        headers: {'content-type': 'application/json'});
  }

  void mockResponse(String responseBody, {int statusCode}) {
    mockWebServer.enqueue(
        body: responseBody,
        httpCode: statusCode ?? 200,
        headers: {'content-type': 'application/json'});
  }

  void assertPostRequest({String body, String path}) {
    final lastRequest = mockWebServer.takeRequest();
    if (lastRequest == null) {
      throw Exception('No request performed or all requests '
          'performed have been already asserted');
    }
    expect(lastRequest.method, 'POST');

    if (path != null) {
      expect(lastRequest.uri.path, path);
    }

    if (body != null) {
      expect(lastRequest.body, body);
    }
  }

  void assertPostRequestFromFile(String fileName, {String path}) {
    final lastRequest = mockWebServer.takeRequest();
    if (lastRequest == null) {
      throw Exception('No request performed or all requests '
          'performed have been already asserted');
    }
    expect(lastRequest.method, 'POST');

    if (path != null) {
      expect(lastRequest.uri.path, path);
    }

    if (fileName != null) {
      expect(json.decode(lastRequest.body),
          json.decode(getStringFromFile(fileName)));
    }
  }

  void assertGetRequest({String path, Map<String, String> queryParameters}) {
    final lastRequest = mockWebServer.takeRequest();
    if (lastRequest == null) {
      throw Exception('No request performed or all requests '
          'performed have been already asserted');
    }
    expect(lastRequest, isNotNull);
    expect(lastRequest.method, 'GET');
    if (path != null) {
      expect(lastRequest.uri.path, path);
    }
    if (queryParameters != null) {
      expect(lastRequest.uri.queryParameters, queryParameters);
    }
  }

  void assertDeleteRequest({String path, Map<String, String> queryParameters}) {
    final lastRequest = mockWebServer.takeRequest();
    if (lastRequest == null) {
      throw Exception('No request performed or all requests '
          'performed have been already asserted');
    }
    expect(lastRequest, isNotNull);
    expect(lastRequest.method, 'DELETE');
    if (path != null) {
      expect(lastRequest.uri.path, path);
    }
    if (queryParameters != null) {
      expect(lastRequest.uri.queryParameters, queryParameters);
    }
  }
}
