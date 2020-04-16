import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/repository/country/country_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';

void main() {
  group('CountryRepository tests', () {
    final _mockCountryApi = MockCountryApi();
    final _subject = CountryRepository(_mockCountryApi);

    setUp(() {
      reset(_mockCountryApi);
    });

    test('getCountries', () async {
      final mockCountryListResponseModel = MockCountryListResponseModel();

      when(_mockCountryApi.getCountryList())
          .thenAnswer((_) => Future.value(mockCountryListResponseModel));

      final result = await _subject.getCountryList();
      expect(result, mockCountryListResponseModel);
      verify(_mockCountryApi.getCountryList()).called(1);
    });
  });
}
