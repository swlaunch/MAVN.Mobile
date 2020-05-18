import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('CountryListBloc tests', () {
    final mockCountryRepository = MockCountryRepository();
    final mockSimCardInfoManager = MockSimCardInfoManager();
    final mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    final expectedFullBlocOutput = <BlocOutput>[];

    final stubCountryList = <Country>[
      TestConstants.stubCountry,
    ];

    BlocTester<CountryListBloc> blocTester;
    CountryListBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = CountryListBloc(mockCountryRepository, mockSimCardInfoManager,
          mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(CountryListUninitializedState());
    });

    test('loadCountryList success, uppercase ISO code', () async {
      final CountryListResponseModel mockResponseModel =
          CountryListResponseModel(countryList: stubCountryList);

      when(mockCountryRepository.getCountryList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      when(mockSimCardInfoManager.getIso2Code()).thenAnswer(
          (_) => Future.value(TestConstants.stubUserIso2CodeUppercase));
      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListLoadedState(countryList: stubCountryList),
        UserCountrySuccessEvent(userCountry: TestConstants.stubCountry)
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('loadCountryList success, lowercase ISO code', () async {
      final CountryListResponseModel mockResponseModel =
          CountryListResponseModel(countryList: stubCountryList);

      when(mockCountryRepository.getCountryList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      when(mockSimCardInfoManager.getIso2Code()).thenAnswer(
          (_) => Future.value(TestConstants.stubUserIso2CodeLowercase));
      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListLoadedState(countryList: stubCountryList),
        UserCountrySuccessEvent(userCountry: TestConstants.stubCountry)
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('loadCountryList connectivity error', () async {
      when(mockCountryRepository.getCountryList())
          .thenThrow(NetworkException());

      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListErrorState(LazyLocalizedStrings.networkError),
      ]);
    });

    test('loadCountryList generic error', () async {
      when(mockCountryRepository.getCountryList()).thenThrow(Exception());
      when(mockExceptionToMessageMapper.map(null)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      ]);
    });

    test(
        'when user ISO does not exist in list, '
        'no event is dispatched', () async {
      final CountryListResponseModel mockResponseModel =
          CountryListResponseModel(countryList: stubCountryList);

      when(mockCountryRepository.getCountryList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      when(mockSimCardInfoManager.getIso2Code())
          .thenAnswer((_) => Future.value('non existent ISO'));
      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListLoadedState(countryList: stubCountryList),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'when user ISO cannot be obtained, '
        'no event is dispatched', () async {
      final CountryListResponseModel mockResponseModel =
          CountryListResponseModel(countryList: stubCountryList);

      when(mockCountryRepository.getCountryList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      when(mockSimCardInfoManager.getIso2Code())
          .thenAnswer((_) => Future.value(null));
      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListLoadedState(countryList: stubCountryList),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'when trying to get user ISO throws exception,'
        'no event is dispatched', () async {
      final CountryListResponseModel mockResponseModel =
          CountryListResponseModel(countryList: stubCountryList);

      when(mockCountryRepository.getCountryList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      when(mockSimCardInfoManager.getIso2Code())
          .thenThrow((_) => TestConstants.stubException);
      await subject.loadCountryList();

      expectedFullBlocOutput.addAll([
        CountryListUninitializedState(),
        CountryListLoadingState(),
        CountryListLoadedState(countryList: stubCountryList),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
