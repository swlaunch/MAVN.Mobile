import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/ui_components/tinted_container.dart';

class VoucherCardWidget extends HookWidget {
  VoucherCardWidget({
    this.imageUrl,
    this.color,
    this.partnerName,
    this.voucherName,
    this.expirationDate,
  });

  final String imageUrl;
  final Color color;
  final String partnerName;
  final String voucherName;
  final DateTime expirationDate;

  static const double _cardBorderRadius = 20;
  static const double _cardHeight = 200;
  static const double _cardInsetSize = 16;
  static const double _topSectionRatio = 0.61;

  final DateFormat _dateFormatCurrentYear = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final expirationDateText = expirationDate != null
        ? localizedStrings
            .offerExpiresOn(_dateFormatCurrentYear.format(expirationDate))
        : localizedStrings.offerNoExpirationDate;

    const topHeight = _cardHeight * _topSectionRatio;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: _cardHeight,
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
                            child: Text(
                              partnerName,
                              style: TextStyles.voucherPartnerName,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //BOTTOM SECTION
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    height: _cardHeight - topHeight,
                    color: color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          voucherName,
                          style: TextStyles.lightHeadersH3,
                        ),
                        Text(
                          expirationDateText,
                          style: TextStyles.body3Light,
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
    );
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
