import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherQRWidget extends StatelessWidget {
  const VoucherQRWidget({
    @required this.partnerId,
    @required this.voucherCode,
    @required this.validationCode,
  });

  static const separator = '&';
  static const partnerIdKey = 'PId=';
  static const shortCodeKey = 'SC=';
  static const validationCodeKey = 'VC=';

  final String partnerId;
  final String voucherCode;
  final String validationCode;

  static const _qrToWidthRatio = 0.45;

  @override
  Widget build(BuildContext context) {
    //TODO extract somewhere that would fit nice architecturally
    final qrValue = '$partnerIdKey$partnerId'
        '$separator'
        '$shortCodeKey$voucherCode'
        '$separator'
        '$validationCodeKey$validationCode';
    print('QRRR $qrValue');
    return QrImage(
      key: const Key('voucherQrCode'),
      data: qrValue,
      size: _qrToWidthRatio * MediaQuery.of(context).size.width,
    );
  }
}
