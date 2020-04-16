import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

// TODO
void main() {
  group('BalanceBloc tests', () {
    final mockCustomerRepository = MockCustomerRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

//    BlocTester<BalanceBloc> blocTester;
//    BalanceBloc subject;

    setUp(() {
      reset(mockCustomerRepository);
      expectedFullBlocOutput.clear();

      //subject = BalanceBloc(mockCustomerRepository);
      //blocTester = BlocTester(subject);
    });

//    test('initialState', () {
//      blocTester.assertCurrentState(BalanceUninitializedState());
//    });
  });
}
