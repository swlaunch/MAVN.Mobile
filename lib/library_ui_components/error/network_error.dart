import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';

class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => GenericErrorIconWidget(
        errorKey: const Key('networkError'),
        title: LocalizedStrings.of(context).networkErrorTitle,
        text: LocalizedStrings.of(context).networkError,
        icon: SvgAssets.networkError,
        onRetryTap: onRetry,
      );
}
