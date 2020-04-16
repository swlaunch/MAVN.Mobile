import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/p2p_transaction_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/payment_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('WalletRepository tests', () {
    final _mockWalletApi = MockWalletApi();
    final _subject = WalletRepository(_mockWalletApi);

    setUp(() {
      reset(_mockWalletApi);
    });

    test('get wallet', () {
      _subject.getWallet();

      verify(_mockWalletApi.getWallet()).called(1);
    });

    test('transaction', () async {
      final mockTransactionResponseModel = MockTransactionResponseModel();

      when(_mockWalletApi.postTransaction(any))
          .thenAnswer((_) => Future.value(mockTransactionResponseModel));

      final transactionResult = await _subject.postTransaction(
          walletAddress: TestConstants.stubEmail,
          amount: TestConstants.stubValidTransactionAmount);

      expect(transactionResult, mockTransactionResponseModel);

      final capturedTransactionRequestModel =
          verify(_mockWalletApi.postTransaction(captureAny)).captured[0]
              as P2pTransactionRequestModel;

      expect(capturedTransactionRequestModel.receiverEmail,
          TestConstants.stubEmail);
      expect(capturedTransactionRequestModel.amount,
          TestConstants.stubValidTransactionAmount);
    });

    test('payment transfer', () async {
      when(_mockWalletApi.postPaymentTransfer(any))
          .thenAnswer((_) => Future.value());
      await _subject.postPaymentTransfer(
          campaignId: TestConstants.stubCampaignId,
          invoiceId: TestConstants.stubInvoiceId,
          amount: TestConstants.stubValidTransactionAmount);

      final capturedPaymentTransferRequestModel =
          verify(_mockWalletApi.postPaymentTransfer(captureAny)).captured[0]
              as PaymentTransferRequestModel;

      expect(capturedPaymentTransferRequestModel.campaignId,
          TestConstants.stubCampaignId);
      expect(capturedPaymentTransferRequestModel.invoiceId,
          TestConstants.stubInvoiceId);
      expect(capturedPaymentTransferRequestModel.amount,
          TestConstants.stubValidTransactionAmount);
    });

    test('unlink wallet', () async {
      await _subject.unlinkExternalWallet();

      verify(_mockWalletApi.unlinkExternalWallet()).called(1);
    });
  });
}
