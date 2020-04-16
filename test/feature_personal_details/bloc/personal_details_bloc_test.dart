import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('PersonalDetailsBloc tests', () {
    final mockCustomerRepository = MockCustomerRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<PersonalDetailsBloc> blocTester;
    PersonalDetailsBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = PersonalDetailsBloc(mockCustomerRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(PersonalDetailsUninitializedState());
    });

    test('getCustomerInfo success', () async {
      when(mockCustomerRepository.getCustomer())
          .thenAnswer((_) => Future.value(TestConstants.stubCustomer));

      await subject.getCustomerInfo();

      expectedFullBlocOutput.addAll([
        PersonalDetailsUninitializedState(),
        PersonalDetailsLoadingState(),
        PersonalDetailsLoadedState(customer: TestConstants.stubCustomer)
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getCustomerInfo both returns connectivity error', () async {
      when(mockCustomerRepository.getCustomer()).thenThrow(NetworkException());

      await subject.getCustomerInfo();

      expectedFullBlocOutput.addAll([
        PersonalDetailsUninitializedState(),
        PersonalDetailsLoadingState(),
        PersonalDetailsNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getCustomerInfo one of returns connectivity error', () async {
      when(mockCustomerRepository.getCustomer()).thenThrow(NetworkException());

      await subject.getCustomerInfo();

      expectedFullBlocOutput.addAll([
        PersonalDetailsUninitializedState(),
        PersonalDetailsLoadingState(),
        PersonalDetailsNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getCustomerInfo both returns generic error', () async {
      when(mockCustomerRepository.getCustomer()).thenThrow(Exception());

      await subject.getCustomerInfo();

      expectedFullBlocOutput.addAll([
        PersonalDetailsUninitializedState(),
        PersonalDetailsLoadingState(),
        PersonalDetailsGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getCustomerInfo one of returns generic error', () async {
      when(mockCustomerRepository.getCustomer()).thenThrow(Exception());

      await subject.getCustomerInfo();

      expectedFullBlocOutput.addAll([
        PersonalDetailsUninitializedState(),
        PersonalDetailsLoadingState(),
        PersonalDetailsGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
