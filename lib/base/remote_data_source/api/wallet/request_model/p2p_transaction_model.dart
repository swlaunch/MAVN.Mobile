class P2pTransactionRequestModel {
  P2pTransactionRequestModel(this.receiverEmail, this.amount);

  final String receiverEmail;
  final String amount;

  Map<String, dynamic> toJson() =>
      {'ReceiverEmail': receiverEmail, 'Amount': amount};
}
