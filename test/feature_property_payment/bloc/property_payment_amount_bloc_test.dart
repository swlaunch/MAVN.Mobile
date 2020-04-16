import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../helpers/bloc.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<PropertyPaymentAmountBloc> _blocTester =
    BlocTester(PropertyPaymentAmountBloc());

PropertyPaymentAmountBloc _subject = PropertyPaymentAmountBloc();

void main() {
  group('PropertyPaymentAmountBlocTests', () {
    setUp(() {
      _expectedFullBlocOutput.clear();

      _subject = PropertyPaymentAmountBloc();
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PropertyPaymentAmountUninitializedState());
    });

    test('initializing', () async {
      await _subject.initialize(
        fullAmount: TestConstants.stubValidTransactionAmount,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentAmountUninitializedState(),
        PropertyPaymentSelectedAmountState(
          amount: TestConstants.stubValidTransactionAmount,
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.full,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: TestConstants.stubValidTransactionAmount,
        )
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('chaging AmountSize type', () async {
      await _subject.initialize(
        fullAmount: TestConstants.stubValidTransactionAmount,
      );
      await _subject.switchAmountSize(AmountSize.partial);

      _expectedFullBlocOutput.addAll([
        PropertyPaymentAmountUninitializedState(),
        PropertyPaymentSelectedAmountState(
          amount: TestConstants.stubValidTransactionAmount,
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.full,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: TestConstants.stubValidTransactionAmount,
        ),
        PropertyPaymentSelectedAmountState(
          amount: '',
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.partial,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: '',
        )
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('set new amount', () async {
      await _subject.initialize(
        fullAmount: TestConstants.stubValidTransactionAmount,
      );
      await _subject.switchAmountSize(AmountSize.partial);

      await _subject.setAmount(TestConstants.stubAmount);
      _expectedFullBlocOutput.addAll([
        PropertyPaymentAmountUninitializedState(),
        PropertyPaymentSelectedAmountState(
          amount: TestConstants.stubValidTransactionAmount,
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.full,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: TestConstants.stubValidTransactionAmount,
        ),
        PropertyPaymentSelectedAmountState(
          amount: '',
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.partial,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: '',
        ),
        PropertyPaymentSelectedAmountState(
          amount: TestConstants.stubAmount,
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: TestConstants.stubAmount,
          amountSize: AmountSize.partial,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('set new amount does not work if AmountSize is full', () async {
      await _subject.initialize(
        fullAmount: TestConstants.stubValidTransactionAmount,
      );

      await _subject.setAmount(TestConstants.stubAmount);
      _expectedFullBlocOutput.addAll([
        PropertyPaymentAmountUninitializedState(),
        PropertyPaymentSelectedAmountState(
          amount: TestConstants.stubValidTransactionAmount,
          fullAmount: TestConstants.stubValidTransactionAmount,
          userInputAmount: '',
          amountSize: AmountSize.full,
        ),
        PropertyPaymentUpdatedAmountEvent(
          amount: TestConstants.stubValidTransactionAmount,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
