import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/external_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/link_advanced_wallet_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/p2p_transaction_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/payment_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/link_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/transaction_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class WalletApi extends BaseApi {
  WalletApi(HttpClient httpClient) : super(httpClient);

  static const String getWalletPath = '/wallets/customer';
  static const String transactionPath = '/wallets/transfer';
  static const String paymentTransferPath = '/wallets/payment-transfer';
  static const String linkRequestPath = '/wallets/linkRequest';
  static const String externalTransferPath = '/wallets/external-transfer';

  Future<WalletResponseModel> getWallet() =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<List<dynamic>>(getWalletPath);
        return WalletResponseModel.fromJson(response.data[0]);
      });

  Future<LinkCodeRequestResponseModel> createPublicLinkCodeRequest() =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.post<dynamic>(linkRequestPath);
        return LinkCodeRequestResponseModel.fromJson(response.data);
      });

  Future<void> postExternalTransfer(ExternalTransferRequestModel amount) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(externalTransferPath,
            data: amount.toJson());
      });

  Future<void> approvePublicWalletLinkingRequest(
          LinkAdvancedWalletRequestModel linkAdvancedWalletRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.put<dynamic>(linkRequestPath,
            data: linkAdvancedWalletRequestModel.toJson());
      });

  Future<void> unlinkExternalWallet() async =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.delete(linkRequestPath);
      });

  Future<TransactionResponseModel> postTransaction(
          P2pTransactionRequestModel transactionRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        final transactionResponse = await httpClient.post<Map<String, dynamic>>(
          transactionPath,
          data: transactionRequestModel.toJson(),
        );

        return TransactionResponseModel.fromJson(transactionResponse.data);
      });

  Future<void> postPaymentTransfer(
          PaymentTransferRequestModel paymentTransferRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          paymentTransferPath,
          data: paymentTransferRequestModel.toJson(),
        );
      });
}
