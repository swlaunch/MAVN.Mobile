import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('CountryCodeListBloc tests', () {
    final mockCountryRepository = MockCountryRepository();
    final mockSimCardInfoManager = MockSimCardInfoManager();
    final mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    final expectedFullBlocOutput = <BlocOutput>[];

    final stubCodesCountryList = <CountryCode>[
      TestConstants.stubCountryCode,
    ];

    BlocTester<CountryCodeListBloc> blocTester;
    CountryCodeListBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = CountryCodeListBloc(mockCountryRepository,
          mockSimCardInfoManager, mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(CountryCodeListUninitializedState());
    });

    test('loadCountryCodeList success', () async {
      final CountryCodeListResponseModel mockResponseModel =
          CountryCodeListResponseModel(countryCodeList: stubCodesCountryList);

      when(mockCountryRepository.getCountryCodeList())
          .thenAnswer((_) => Future.value(mockResponseModel));

      await subject.loadCountryCodeList();

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
        CountryCodeListLoadingState(),
        CountryCodeListLoadedState(countryCodeList: stubCodesCountryList),
        CountryCodeListLoadedEvent(countryCodeList: stubCodesCountryList),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('loadCountryCodeList connectivity error', () async {
      when(mockCountryRepository.getCountryList())
          .thenThrow(NetworkException());

      await subject.loadCountryCodeList();

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
        CountryCodeListLoadingState(),
        CountryCodeListErrorState(LazyLocalizedStrings.networkError),
      ]);
    });

    test('loadCountryCodeList generic error', () async {
      when(mockCountryRepository.getCountryList()).thenThrow(Exception());
      when(mockExceptionToMessageMapper.map(null)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await subject.loadCountryCodeList();

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
        CountryCodeListLoadingState(),
        CountryCodeListErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      ]);
    });

    test('getCountryCodeFromSim success, uppercase ISO code', () async {
      when(mockSimCardInfoManager.getIso2Code()).thenAnswer(
          (_) => Future.value(TestConstants.stubUserIso2CodeUppercase));

      await subject.getCountryCodeFromSim(stubCodesCountryList);

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
        UserSimCountryCodeSuccessEvent(
            userCountryCode: TestConstants.stubCountryCode),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getCountryCodeFromSim success, lowercase ISO code', () async {
      when(mockSimCardInfoManager.getIso2Code()).thenAnswer(
          (_) => Future.value(TestConstants.stubUserIso2CodeLowercase));

      await subject.getCountryCodeFromSim(stubCodesCountryList);

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
        UserSimCountryCodeSuccessEvent(
            userCountryCode: TestConstants.stubCountryCode),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'when user ISO does not exist in list, '
        'no event is dispatched', () async {
      when(mockSimCardInfoManager.getIso2Code())
          .thenAnswer((_) => Future.value('non existent ISO'));

      await subject.getCountryCodeFromSim(stubCodesCountryList);

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'when user ISO cannot be obtained, '
        'no event is dispatched', () async {
      when(mockSimCardInfoManager.getIso2Code())
          .thenAnswer((_) => Future.value(null));

      await subject.getCountryCodeFromSim(stubCodesCountryList);

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test(
        'when trying to get user ISO throws exception,'
        'no event is dispatched', () async {
      when(mockSimCardInfoManager.getIso2Code())
          .thenThrow((_) => TestConstants.stubException);

      await subject.getCountryCodeFromSim(stubCodesCountryList);

      expectedFullBlocOutput.addAll([
        CountryCodeListUninitializedState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
