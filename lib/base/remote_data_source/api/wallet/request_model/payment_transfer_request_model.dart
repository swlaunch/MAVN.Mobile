class PaymentTransferRequestModel {
  PaymentTransferRequestModel({this.campaignId, this.invoiceId, this.amount});

  final String campaignId;
  final String invoiceId;
  final String amount;

  Map<String, dynamic> toJson() => {
        'CampaignId': campaignId,
        'InvoiceId': invoiceId,
        'Amount': amount,
      };
}
