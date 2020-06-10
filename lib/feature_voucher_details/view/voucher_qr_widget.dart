import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/qr_content.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/voucher_qr_content.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherQRWidget extends StatelessWidget {
  const VoucherQRWidget({
    @required this.partnerId,
    @required this.voucherCode,
    @required this.validationCode,
  });

  final String partnerId;
  final String voucherCode;
  final String validationCode;

  static const _qrToWidthRatio = 0.45;

  @override
  Widget build(BuildContext context) {
    //TODO extract somewhere that would fit nice architecturally
    final qrValue = '${VoucherQrContent.partnerIdKey}$partnerId'
        '${QrContent.separator}'
        '${VoucherQrContent.shortCodeKey}$voucherCode';
    return QrImage(
      key: const Key('voucherQrCode'),
      data: qrValue,
      size: _qrToWidthRatio * MediaQuery.of(context).size.width,
    );
  }
}
