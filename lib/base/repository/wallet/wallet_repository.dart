import 'package:decimal/decimal.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/external_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/link_advanced_wallet_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/p2p_transaction_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/payment_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/link_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/transaction_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/wallet_api.dart';

class WalletRepository {
  WalletRepository(this._walletApi);

  final WalletApi _walletApi;

  Future<WalletResponseModel> getWallet() => _walletApi.getWallet();

  Future<LinkCodeRequestResponseModel> createPublicLinkCodeRequest() =>
      _walletApi.createPublicLinkCodeRequest();

  Future<void> postExternalTransfer(Decimal amount) => _walletApi
      .postExternalTransfer(ExternalTransferRequestModel(amount: amount));

  Future<void> approvePublicWalletLinkingRequest(
          {String privateAddress, String publicAddress, String signature}) =>
      _walletApi.approvePublicWalletLinkingRequest(
          LinkAdvancedWalletRequestModel(
              publicAddress: publicAddress,
              privateAddress: privateAddress,
              signature: signature));

  Future<void> unlinkExternalWallet() => _walletApi.unlinkExternalWallet();

  Future<TransactionResponseModel> postTransaction(
          {String walletAddress, String amount}) =>
      _walletApi
          .postTransaction(P2pTransactionRequestModel(walletAddress, amount));

  Future<void> postPaymentTransfer(
          {String campaignId, String invoiceId, String amount}) =>
      _walletApi.postPaymentTransfer(PaymentTransferRequestModel(
          campaignId: campaignId, invoiceId: invoiceId, amount: amount));
}
