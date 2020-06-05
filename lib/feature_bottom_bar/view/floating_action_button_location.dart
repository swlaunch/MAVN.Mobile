import 'dart:math';

import 'package:flutter/material.dart';

// This class is copied from material/floating_action_button_location.dart
// We needed to create our own FloatingActionButtonLocation
// to be able to adjust fabY
class CenterDockedFloatingActionButtonLocation
    extends _DockedFloatingActionButtonLocation {
  const CenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }

  @override
  String toString() => 'FloatingActionButtonLocation.centerDocked';
}

// Provider of common logic for [FloatingActionButtonLocation]s that
// dock to the [BottomAppBar].
abstract class _DockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _DockedFloatingActionButtonLocation();

  // Positions the Y coordinate of the [FloatingActionButton] at a height
  // where it docks to the [BottomAppBar].
  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final contentBottom = scaffoldGeometry.contentBottom;
    final bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final snackBarHeight = scaffoldGeometry.snackBarSize.height;

    var fabY = contentBottom - fabHeight / 6.0;
    // The FAB should sit with a margin between it and the snack bar.
    if (snackBarHeight > 0.0) {
      fabY = min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    }
    // The FAB should sit with its center in front of the top of the bottom
    // sheet.
    if (bottomSheetHeight > 0.0) {
      fabY = min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    }
    final maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return min(maxFabY, fabY);
  }
}
