import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';
import 'package:meta/meta.dart';

class WalletResponseModel {
  WalletResponseModel({
    @required this.balance,
    this.walletLinkingStatus,
    this.publicWalletAddress,
    this.privateWalletAddress,
    this.transitAccountAddress,
    this.totalSpent,
    this.totalEarned,
    this.stakedBalance,
    this.isWalletBlocked,
    this.externalBalance,
  });

  WalletResponseModel.fromJson(Map<String, dynamic> json)
      : balance = TokenCurrency(
          value: json['Balance'],
          assetSymbol: json['AssetSymbol'],
        ),
        externalBalance = TokenCurrency(
          value: json['ExternalBalance'],
          assetSymbol: json['AssetSymbol'],
        ),
        isWalletBlocked = json['IsWalletBlocked'],
        totalSpent = json['TotalSpent'] == null
            ? null
            : TokenCurrency(
                value: json['TotalSpent'],
                assetSymbol: json['AssetSymbol'],
              ),
        totalEarned = json['TotalEarned'] == null
            ? null
            : TokenCurrency(
                value: json['TotalEarned'],
                assetSymbol: json['AssetSymbol'],
              ),
        stakedBalance = json['StakedBalance'] == null
            ? null
            : TokenCurrency(
                value: json['StakedBalance'],
                assetSymbol: json['AssetSymbol'],
              ),
        walletLinkingStatus = EnumMapper.mapFromString(
            json['PublicAddressLinkingStatus'],
            enumValues: WalletLinkingStatusType.values,
            defaultValue: WalletLinkingStatusType.notLinked),
        privateWalletAddress = json['PrivateWalletAddress'],
        publicWalletAddress = json['PublicWalletAddress'],
        transitAccountAddress = json['TransitAccountAddress'];

  final TokenCurrency balance;
  final TokenCurrency externalBalance;
  final bool isWalletBlocked;
  final TokenCurrency totalSpent;
  final TokenCurrency totalEarned;
  final TokenCurrency stakedBalance;
  final WalletLinkingStatusType walletLinkingStatus;
  final String privateWalletAddress;
  final String publicWalletAddress;
  final String transitAccountAddress;
}

enum WalletLinkingStatusType {
  notLinked,
  pending,
  pendingCustomerApproval,
  pendingConfirmationInBlockchain,
  linked
}
