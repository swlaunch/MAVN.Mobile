import 'package:mock_web_server/mock_web_server.dart';

import '../../test/helpers/file.dart';

class MockServerDispatcher {
  MockServerDispatcher() {
    _dispatcher = (request) async {
      final method = request.method.toLowerCase();

      for (final key in enqueuedResponses.keys) {
        if (request.uri.toString().contains(key) &&
            enqueuedResponses[key].containsKey(method)) {
          final response = enqueuedResponses[key][method].toMockResponse();
          enqueuedResponses[key].remove(method);
          return response;
        }
      }

      for (final key in defaultResponses.keys) {
        if (request.uri.toString().contains(key)) {
          final pathEntry = defaultResponses[key];
          if (pathEntry.containsKey(method)) {
            return pathEntry[method].toMockResponse();
          }
        }
      }

      return MockResponse()..httpCode = 404;
    };
  }

  Dispatcher get dispatcher => _dispatcher;
  Dispatcher _dispatcher;

  final Map<String, Map<String, MockResponseFromFile>> enqueuedResponses = {};

  final Map<String, Map<String, MockResponseFromFile>> defaultResponses = {
    '/auth/login': {
      'post': MockResponseFromFile(
        filePath: 'test_resources/mock_data/login/response/200.json',
        responseStatusCode: 200,
      ),
    },
    '/customers/register': {
      'post': MockResponseFromFile(
        filePath: 'test_resources/mock_data/register/response/200.json',
        responseStatusCode: 200,
      ),
    },
    '/wallets/customer': {
      'get': MockResponseFromFile(
        filePath: 'test_resources/mock_data/wallets/customer/response/200.json',
        responseStatusCode: 200,
      ),
    },
    '/referrals/lead': {
      'post': MockResponseFromFile(
        filePath: 'test_resources/mock_data/referrals/lead/response/204.json',
        responseStatusCode: 204,
      ),
    },
    '/referrals/leads': {
      'get': MockResponseFromFile(
        filePath: 'test_resources/mock_data/referrals/leads/response/200.json',
        responseStatusCode: 200,
      ),
    },
    '/lists/countryPhoneCodes': {
      'get': MockResponseFromFile(
        filePath: 'test_resources/mock_data/countryCodes/response/'
            '200.json',
        responseStatusCode: 200,
      ),
    },
    '/lists/countriesOfResidence': {
      'get': MockResponseFromFile(
        filePath: 'test_resources/mock_data/country/response/'
            '200.json',
        responseStatusCode: 200,
      ),
    },
    'wallets/transfer': {
      'post': MockResponseFromFile(
        filePath: 'test_resources/mock_data/p2p_transactions/response/200.json',
        responseStatusCode: 200,
      ),
    },
  };
}

class MockResponseFromFile {
  MockResponseFromFile(
      {this.filePath, this.responseStatusCode, this.willTimeout = false});

  final String filePath;
  final int responseStatusCode;
  final bool willTimeout;

  MockResponse toMockResponse() => MockResponse()
    ..body = getStringFromFile(filePath)
    ..httpCode = responseStatusCode
    ..headers = {'content-type': 'application/json'}
    ..delay = willTimeout ? const Duration(seconds: 4) : Duration.zero;
}
