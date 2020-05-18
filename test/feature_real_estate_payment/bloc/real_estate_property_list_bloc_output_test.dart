import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockSpendRepository = MockSpendRepository();

BlocTester<PropertyListBloc> _blocTester =
    BlocTester(PropertyListBloc(_mockSpendRepository));

PropertyListBloc _subject;

void main() {
  group('PropertyListBlocTests', () {
    setUp(() {
      reset(_mockSpendRepository);
      _expectedFullBlocOutput.clear();

      _subject = PropertyListBloc(_mockSpendRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PropertyListUninitializedState());
    });

    test('get property success,empty', () async {
      when(
        _mockSpendRepository.getProperties(
          spendRuleId: anyNamed('spendRuleId'),
        ),
      ).thenAnswer((_) => Future.value(
          const RealEstatePropertyListResponseModel(properties: [])));

      await _subject.loadProperties(TestConstants.stubSpendRuleId);

      verify(_mockSpendRepository.getProperties(
        spendRuleId: TestConstants.stubSpendRuleId,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        PropertyListUninitializedState(),
        PropertyListLoadingState(),
        PropertyListEmptyState(),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get property success', () async {
      const _propertyResponse =
          RealEstatePropertyListResponseModel(properties: [Property()]);
      when(
        _mockSpendRepository.getProperties(
          spendRuleId: anyNamed('spendRuleId'),
        ),
      ).thenAnswer((_) => Future.value(_propertyResponse));

      await _subject.loadProperties(TestConstants.stubSpendRuleId);

      verify(_mockSpendRepository.getProperties(
        spendRuleId: TestConstants.stubSpendRuleId,
      )).called(1);

      _expectedFullBlocOutput.addAll([
        PropertyListUninitializedState(),
        PropertyListLoadingState(),
        PropertyListLoadedState(properties: _propertyResponse.properties),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get properties generic error', () async {
      when(
        _mockSpendRepository.getProperties(
          spendRuleId: anyNamed('spendRuleId'),
        ),
      ).thenThrow(Exception());

      await _subject.loadProperties(TestConstants.stubSpendRuleId);

      _expectedFullBlocOutput.addAll([
        PropertyListUninitializedState(),
        PropertyListLoadingState(),
        PropertyListErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get properties network error', () async {
      when(
        _mockSpendRepository.getProperties(
          spendRuleId: anyNamed('spendRuleId'),
        ),
      ).thenThrow(NetworkException());

      await _subject.loadProperties(TestConstants.stubSpendRuleId);

      _expectedFullBlocOutput.addAll([
        PropertyListUninitializedState(),
        PropertyListLoadingState(),
        PropertyListNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
