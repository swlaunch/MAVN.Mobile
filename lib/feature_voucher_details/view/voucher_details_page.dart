import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/ui_components/voucher_about_section.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/ui_components/voucher_top_section.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/ui_components/voucher_widget.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/scroll_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/bottom_primary_button.dart';

class VoucherDetailsPage extends HookWidget {
  const VoucherDetailsPage({@required this.voucher});

  static const double _sliverImageSize = 200;

  final VoucherResponseModel voucher;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();

    final router = useRouter();

    final scrollController = useScrollController();

    return Scaffold(
      backgroundColor: ColorStyles.offWhite,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _sliverImageSize,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  color: ColorStyles.geraldine,
                  child: FlexibleSpaceBar(
                    background: Container(
                      color: ColorStyles.geraldine,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      VoucherTopSection(
                        vendor: voucher.partnerName,
                        offerName: voucher.name,
                        expirationDate: voucher.toDate,
                      ),
                      const SizedBox(height: 32),
                      VoucherAboutSection(about: voucher.description),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildVoucherCard(context, scrollController),
          BottomPrimaryButton(
            text: localizedStrings.redeemOffer,
            onTap: () =>
                router.pushComingSoonPage(title: localizedStrings.redeemOffer),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(
      BuildContext context, ScrollController scrollController) {
    //starting widget position
    final defaultTopMargin =
        _sliverImageSize + MediaQuery.of(context).padding.top - 150.0;
    //pixels from top where opacity change should start
    final double opacityChangeStart = defaultTopMargin / 2;
    //pixels from top where opacity change should end
    final double opacityChangeEnd = opacityChangeStart / 2;

    double top = defaultTopMargin;
    double opacity = 1;
    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - opacityChangeStart) {
        //offset small => don't decrease opacity
        opacity = 1;
      } else if (offset < defaultTopMargin - opacityChangeEnd) {
        //opacityChangeStart < offset> opacityChangeEnd => decrease opacity
        opacity =
            (defaultTopMargin - opacityChangeEnd - offset) / opacityChangeEnd;
      } else {
        //offset passed opacityChangeEnd => hide widget
        opacity = 0;
      }
    }
    final availableWidth = MediaQuery.of(context).size.width;

    final width = availableWidth - (2 * 24);
    return Positioned(
      top: top + 24,
      left: 24,
      child: Opacity(
        opacity: opacity,
        child: Hero(
          tag: 'voucher_${voucher.id}',
          child: Container(
            width: width,
            child: VoucherWidget(
              title: voucher.name,
              price: voucher.price,
              imageUrl: voucher.getImageUrl(),
            ),
          ),
        ),
      ),
    );
  }
}
