import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

/// This mixin allows an [OverlayEntry] to be presented on the screen.
/// It occupies the entire screen with a cloudy
/// blue background and a centered spinner.
///
/// Usually used on loading activities that should prevent any user actions.
///
mixin LoadingOverlayMixin {
  final _overlayEntry = OverlayEntry(
    builder: (context) => Container(
        color: ColorStyles.cloudyBlue.withOpacity(0.3),
        child: const Center(
          child: Spinner(),
        )),
  );

  /// Show an overlay on top of the entire screen
  /// with a centered loading indicator
  void showLoadingOverlay(BuildContext context) =>
      Overlay.of(context).insert(_overlayEntry);

  /// Hide the overlay loading indicator, which is presented on the screen.
  void hideLoadingOverlay(BuildContext context, {bool show}) =>
      _overlayEntry.remove();
}
