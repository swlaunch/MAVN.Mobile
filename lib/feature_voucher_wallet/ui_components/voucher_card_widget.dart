import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/tinted_container.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/price_tag.dart';

class VoucherCardWidget extends HookWidget {
  VoucherCardWidget({
    this.imageUrl,
    this.color,
    this.partnerName,
    this.voucherName,
    this.expirationDate,
    this.purchaseDate,
    this.voucherStatus,
    this.price,
  });

  final String imageUrl;
  final Color color;
  final String partnerName;
  final String voucherName;
  final DateTime expirationDate;
  final DateTime purchaseDate;
  final VoucherStatus voucherStatus;
  final FiatCurrency price;

  static const double _cardBorderRadius = 20;
  static const double cardHeight = 210;
  static const double _cardInsetSize = 16;
  static const double _topSectionRatio = 0.60;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 8;
  final DateFormat _dateFormatCurrentYear = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final expirationDateText = expirationDate != null
        ? localizedStrings
            .expirationDate(_dateFormatCurrentYear.format(expirationDate))
        : localizedStrings.offerNoExpirationDate;
    final purchaseDateText = localizedStrings
        .dateOfPurchase(_dateFormatCurrentYear.format(purchaseDate));

    const topHeight = cardHeight * _topSectionRatio;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardBorderRadius),
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: cardHeight,
                  child: Column(
                    children: <Widget>[
                      //TOP SECTION
                      Container(
                        height: topHeight,
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            TintedContainer(
                              color: color,
                              imageUrl: imageUrl,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: AutoSizeText(
                                        partnerName,
                                        style: TextStyles.voucherPartnerName,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildTag(localizedStrings),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //BOTTOM SECTION
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        width: double.infinity,
                        height: cardHeight - topHeight,
                        color: color,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: AutoSizeText(
                                voucherName,
                                maxLines: 1,
                                style: TextStyles.lightHeadersH3,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(
                                expirationDateText,
                                maxLines: 1,
                                style: TextStyles.body3Light,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(
                                purchaseDateText,
                                maxLines: 1,
                                style: TextStyles.body3Light,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///THESE HAVE TO STAY ON TOP OF THE STACK
                Positioned(
                  right: 0,
                  top: topHeight - (_cardInsetSize / 2),
                  child: _buildInset(),
                ),
                Positioned(
                  left: 0,
                  top: topHeight - (_cardInsetSize / 2),
                  child: _buildInset(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 16,
          child: PriceTag(price: price),
        ),
      ],
    );
  }

  Widget _buildTag(LocalizedStrings localizedStrings) {
    if (voucherStatus == VoucherStatus.reserved) {
      return _VoucherTag(
        text: localizedStrings.pending,
        color: ColorStyles.white,
        textColor: ColorStyles.selectiveYellow,
      );
    }

    if (expirationDate != null && DateTime.now().isAfter(expirationDate)) {
      return _VoucherTag(
        text: localizedStrings.expired,
        color: ColorStyles.black,
        textColor: ColorStyles.white,
      );
    }
    return Container();
  }

  Widget _buildInset() => SizedBox(
        width: _cardInsetSize / 8,
        height: _cardInsetSize,
        child: OverflowBox(
          minWidth: 0,
          maxWidth: _cardInsetSize,
          minHeight: 0,
          maxHeight: _cardInsetSize,
          child: _buildCircle(),
        ),
      );

  Widget _buildCircle() => Container(
        child: Container(
          height: _cardInsetSize,
          width: _cardInsetSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
}

class _VoucherTag extends StatelessWidget {
  const _VoucherTag({
    @required this.text,
    @required this.color,
    @required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style: TextStyles.body3Light.copyWith(color: textColor),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
      );
}
