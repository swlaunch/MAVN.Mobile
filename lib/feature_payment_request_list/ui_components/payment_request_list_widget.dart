import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/ui_components/payment_request_status_card.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class PaymentRequestListWidget extends StatelessWidget {
  const PaymentRequestListWidget({
    this.data,
    this.loadData,
    this.onItemTap,
    this.isLoading,
    this.isInitiallyLoading,
    this.emptyStateText,
    this.isEmpty,
    this.showError,
    this.errorText,
    this.retryOnError,
    this.refreshCallback,
  });

  final Function loadData;
  final List<PaymentRequestResponseModel> data;
  final Function onItemTap;
  final bool isLoading;
  final bool isInitiallyLoading;
  final String emptyStateText;
  final bool isEmpty;
  final bool showError;
  final String errorText;
  final VoidCallback retryOnError;
  final RefreshCallback refreshCallback;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          RefreshIndicator(
            color: ColorStyles.gold1,
            onRefresh: refreshCallback,
            child: InfiniteListWidget(
              data: data,
              loadData: loadData,
              padding: const EdgeInsets.all(16),
              backgroundColor: ColorStyles.offWhite,
              isLoading: isLoading,
              isEmpty: isEmpty,
              emptyText: emptyStateText,
              emptyIcon: SvgAssets.paymentRequests,
              retryOnError: retryOnError,
              showError: showError,
              errorText: errorText,
              itemBuilder: (item, onTap, _) =>
                  PaymentRequestStatusCard(item, onItemTap),
              separatorBuilder: (position) => const SizedBox(height: 16),
            ),
          ),
          if (isInitiallyLoading)
            const Center(
              child: Spinner(),
            )
        ],
      );
}
