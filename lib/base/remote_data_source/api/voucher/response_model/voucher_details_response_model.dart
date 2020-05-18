import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';

class VoucherDetailsResponseModel {
  VoucherDetailsResponseModel({
    @required this.validationCode,
    @required this.voucher,
  });

  VoucherDetailsResponseModel.fromJson(Map<String, dynamic> json)
      : validationCode = json['ValidationCode'],
        voucher = VoucherResponseModel.fromJson(json);

  final String validationCode;
  final VoucherResponseModel voucher;
}
