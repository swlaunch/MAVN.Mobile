import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_coming_soon/view/coming_soon_page.dart';

class VoucherDetailsPage extends HookWidget {
  const VoucherDetailsPage({@required this.voucher});

  final VoucherResponseModel voucher;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    return ComingSoonPage(title: localizedStrings.viewVoucher);
  }
}
