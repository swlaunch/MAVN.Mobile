import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/bloc/maintenance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/bloc/maintenance_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockMobileRepository _mobileRepository = MockMobileRepository();

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<MaintenanceBloc> _blocTester;
MaintenanceBloc _subject;
final _localizedStrings = LocalizedStrings();

void main() {
  group('MaintenanceBloc tests', () {
    setUp(() {
      reset(_mobileRepository);
      _expectedFullBlocOutput.clear();

      _subject = MaintenanceBloc(_mobileRepository);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(MaintenanceStateUninitializedState());
    });

    test('errorState', () {
      void testErrorMessage(int duration, String errorMessage) {
        _subject.setInitialDurationPeriod(duration);
        assertMaintenanceErrorStateMessage(errorMessage);
      }

      testErrorMessage(160, '2 hours');
      testErrorMessage(180, '3 hours');
      testErrorMessage(-160, '1 hour');
      testErrorMessage(119, '1 hour');
      testErrorMessage(null, 'couple of hours');
    });

    test('retry', () async {
      givenMobileRepositoryWillThrow(160);
      await _subject.retry();
      assertMaintenanceErrorStateMessage('2 hours');

      givenMobileRepositoryWillThrow(null, statusCode: 400);
      await _subject.retry();
      assertMaintenanceErrorStateMessage('couple of hours');

      givenMobileRepositoryWillReturnSuccess();
      await _subject.retry();
      await _blocTester.assertCurrentState(MaintenanceSuccessState());
    });
  });
}

void givenMobileRepositoryWillThrow(int duration, {int statusCode = 503}) {
  when(_mobileRepository.getSettings()).thenThrow(DioError(
      response: Response(
          statusCode: statusCode,
          data: {'ExpectedRemainingDurationInMinutes': duration})));
}

void givenMobileRepositoryWillReturnSuccess() {
  when(_mobileRepository.getSettings())
      .thenAnswer((_) => Future.value(TestConstants.stubMobileSettings));
}

void assertMaintenanceErrorStateMessage(String errorMessage) {
  _blocTester.assertCurrentStateType(MaintenanceErrorState);
  final blockErrorState = _blocTester.currentState as MaintenanceErrorState;
  expect(blockErrorState.remainingMaintenanceDuration.from(_localizedStrings),
      errorMessage);
}
