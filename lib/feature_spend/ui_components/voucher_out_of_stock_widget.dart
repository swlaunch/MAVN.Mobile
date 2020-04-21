import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/offer_unavailable_widget.dart';

class VoucherOutOfStockWidget extends BaseOfferUnavailableWidget {
  VoucherOutOfStockWidget(this.router)
      : super(
          title: LazyLocalizedStrings.earnRuleDetailsOfferUnavailableTitle,
          buttonText: LazyLocalizedStrings.earnRuleViewOtherOffers,
          bodyBuilder: (context) =>
              Text(LocalizedStrings.of(context).outOfStockDescription),
          onButtonTap: router.pop,
        );
  final Router router;
}
