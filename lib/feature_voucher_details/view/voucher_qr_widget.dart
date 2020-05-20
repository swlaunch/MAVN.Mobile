import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherQRWidget extends StatelessWidget {
  const VoucherQRWidget({@required this.voucherCode});

  final String voucherCode;

  static const _qrToWidthRatio = 0.45;

  @override
  Widget build(BuildContext context) => QrImage(
        key: const Key('voucherQrCode'),
        data: voucherCode,
        size: _qrToWidthRatio * MediaQuery.of(context).size.width,
      );
}
