import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockWalletRepository = MockWalletRepository();
final _mockTransactionAnalyticsManager = MockTransactionFormAnalyticsManager();
final _mockBarcodeScanManager = MockBarcodeScannerManager();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<TransactionFormBloc> _blocTester = BlocTester(TransactionFormBloc(
  _mockWalletRepository,
  _mockTransactionAnalyticsManager,
  _mockBarcodeScanManager,
  _mockExceptionToMessageMapper,
));

TransactionFormBloc _subject;

void main() {
  group('TransactionFormBlocTests', () {
    setUp(() {
      reset(_mockWalletRepository);
      _expectedFullBlocOutput.clear();

      _subject = TransactionFormBloc(
          _mockWalletRepository,
          _mockTransactionAnalyticsManager,
          _mockBarcodeScanManager,
          _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(TransactionFormUninitializedState());
    });

    test('submitTransactionForm success', () async {
      await _subject.postTransaction(
          walletAddress: ' ${TestConstants.stubEmail} ',
          amount: TestConstants.stubValidTransactionAmount);

      expect(
        verify(_mockWalletRepository.postTransaction(
                walletAddress: TestConstants.stubEmail,
                amount: TestConstants.stubValidTransactionAmount))
            .callCount,
        1,
      );
      verify(_mockTransactionAnalyticsManager.transactionDone()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        TransactionFormLoadingState(),
        TransactionFormSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('postTransaction generic error', () async {
      when(_mockWalletRepository.postTransaction(
              walletAddress: TestConstants.stubEmail,
              amount: TestConstants.stubValidTransactionAmount))
          .thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.postTransaction(
          walletAddress: TestConstants.stubEmail,
          amount: TestConstants.stubValidTransactionAmount);

      verify(_mockTransactionAnalyticsManager.transactionFailed()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        TransactionFormLoadingState(),
        TransactionFormErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('postTransactionForm network error', () async {
      when(_mockWalletRepository.postTransaction(
              walletAddress: TestConstants.stubEmail,
              amount: TestConstants.stubValidTransactionAmount))
          .thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.postTransaction(
          walletAddress: TestConstants.stubEmail,
          amount: TestConstants.stubValidTransactionAmount);

      verify(_mockTransactionAnalyticsManager.transactionFailed()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        TransactionFormLoadingState(),
        TransactionFormErrorState(LazyLocalizedStrings.networkError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('postTransactionForm The Receiver does not exist error', () async {
      when(_mockWalletRepository.postTransaction(
              walletAddress: TestConstants.stubEmail,
              amount: TestConstants.stubValidTransactionAmount))
          .thenThrow(const ServiceException(
              ServiceExceptionType.invalidReceiver,
              message: 'The Receiver does not exist'));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom('The Receiver does not exist'));

      await _subject.postTransaction(
          walletAddress: TestConstants.stubEmail,
          amount: TestConstants.stubValidTransactionAmount);

      verify(_mockTransactionAnalyticsManager.transactionFailed()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        TransactionFormLoadingState(),
        TransactionFormInlineErrorState(
            LocalizedStringBuilder.custom('The Receiver does not exist')),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('postTransactionForm Wallet Disabled error', () async {
      when(_mockWalletRepository.postTransaction(
              walletAddress: TestConstants.stubEmail,
              amount: TestConstants.stubValidTransactionAmount))
          .thenThrow(const ServiceException(
        ServiceExceptionType.transferSourceCustomerWalletBlocked,
        message: TestConstants.stubErrorText,
      ));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await _subject.postTransaction(
          walletAddress: TestConstants.stubEmail,
          amount: TestConstants.stubValidTransactionAmount);

      verify(_mockTransactionAnalyticsManager.transactionFailed()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        TransactionFormLoadingState(),
        TransactionFormWalletDisabledEvent(),
        TransactionFormInlineErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText))
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('startScan success', () async {
      when(_mockBarcodeScanManager.startScan())
          .thenAnswer((_) => Future<String>.value(TestConstants.stubBarcode));

      await _subject.startScan();

      verify(_mockBarcodeScanManager.startScan()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        BarcodeUninitializedState(),
        BarcodeScanSuccessEvent(TestConstants.stubBarcode),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('startScan permission error', () async {
      when(_mockBarcodeScanManager.startScan()).thenThrow(
          PlatformException(code: BarcodeScanner.CameraAccessDenied));

      await _subject.startScan();

      verify(_mockBarcodeScanManager.startScan()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        BarcodeUninitializedState(),
        BarcodeScanPermissionErrorState(
            LazyLocalizedStrings.barcodeScanPermissionError),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('startScan platform-generic error', () async {
      when(_mockBarcodeScanManager.startScan())
          .thenThrow(PlatformException(code: 'code'));

      await _subject.startScan();

      verify(_mockBarcodeScanManager.startScan()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        BarcodeUninitializedState(),
        BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('startScan generic error', () async {
      when(_mockBarcodeScanManager.startScan()).thenThrow(Exception());

      await _subject.startScan();

      verify(_mockBarcodeScanManager.startScan()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        BarcodeUninitializedState(),
        BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('startScan back button should not change state', () async {
      when(_mockBarcodeScanManager.startScan())
          .thenThrow(const FormatException());

      await _subject.startScan();

      verify(_mockBarcodeScanManager.startScan()).called(1);

      _expectedFullBlocOutput.addAll([
        TransactionFormUninitializedState(),
        BarcodeUninitializedState(),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });
  });
}
