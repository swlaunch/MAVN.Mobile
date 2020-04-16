class LinkAdvancedWalletRequestModel {
  LinkAdvancedWalletRequestModel({
    this.privateAddress,
    this.publicAddress,
    this.signature,
  });

  final String privateAddress;
  final String publicAddress;
  final String signature;

  Map<String, dynamic> toJson() => {
        'PrivateAddress': privateAddress,
        'PublicAddress': publicAddress,
        'Signature': signature,
      };
}
