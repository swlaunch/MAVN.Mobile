import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockDateTimeManager = MockDateTimeManager();
BlocTester<InstalmentListBloc> _blocTester =
    BlocTester(InstalmentListBloc(_mockDateTimeManager));

InstalmentListBloc _subject;

void main() {
  group('InstalmentListBlocTests', () {
    setUp(() {
      reset(_mockDateTimeManager);
      _expectedFullBlocOutput.clear();

      _subject = InstalmentListBloc(_mockDateTimeManager);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(InstalmentListUninitializedState());
    });

    test('map empty list', () async {
      await _subject.mapInstalments([]);

      _expectedFullBlocOutput.addAll([
        InstalmentListUninitializedState(),
        InstalmentListLoadingState(),
        InstalmentListLoadedState(extendedInstalments: []),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('map overdue item', () async {
      final now = DateTime.now();
      final _propertyResponse = Property(
        name: TestConstants.stubName,
        instalments: [TestConstants.stubInstalment],
      );

      final yesterday = DateTime(now.year, now.month, now.day - 1);
      when(
        _mockDateTimeManager.toLocal(TestConstants.stubInstalment.dueDate),
      ).thenReturn(yesterday);

      final _expectedExtendedInstalment = ExtendedInstalmentModel(
        instalment: TestConstants.stubInstalment,
        isOverdue: true,
        localDueDate: yesterday,
        formattedDate: _mockDateTimeManager
            .formatShortBasedOnYear(TestConstants.stubDateTime),
      );

      await _subject.mapInstalments(_propertyResponse.instalments);

      _expectedFullBlocOutput.addAll([
        InstalmentListUninitializedState(),
        InstalmentListLoadingState(),
        InstalmentListLoadedState(
            extendedInstalments: [_expectedExtendedInstalment]),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('map item in the future', () async {
      final now = DateTime.now();
      final _propertyResponse = Property(
        name: TestConstants.stubName,
        instalments: [TestConstants.stubInstalment],
      );

      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      when(
        _mockDateTimeManager.toLocal(TestConstants.stubInstalment.dueDate),
      ).thenReturn(tomorrow);

      final _expectedExtendedInstalment = ExtendedInstalmentModel(
        instalment: TestConstants.stubInstalment,
        isOverdue: false,
        localDueDate: tomorrow,
        formattedDate: _mockDateTimeManager
            .formatShortBasedOnYear(TestConstants.stubDateTime),
      );

      await _subject.mapInstalments(_propertyResponse.instalments);

      _expectedFullBlocOutput.addAll([
        InstalmentListUninitializedState(),
        InstalmentListLoadingState(),
        InstalmentListLoadedState(
            extendedInstalments: [_expectedExtendedInstalment]),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });
  });
}
