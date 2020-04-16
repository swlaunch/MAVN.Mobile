import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/di/hotel_pre_checkout_di.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/view/hotel_pre_checkout_dialog.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  setUpAll(() {
    initScreenshots();
  });

  group('HotelPreCheckoutDialog tests', () {
    testWidgets('Hotel pre checkout dialog displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheHotelPreCheckoutDialogPageWithBlocState(
          widgetTester,
          HotelPreCheckoutLoadedState(
            partnerName: TestConstants.stubPartnerMessage.partnerName,
            message: TestConstants.stubPartnerMessage.message,
          ));

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byType(HotelPreCheckoutDialog), 'hotel_pre_checkout_dialog');
    });
  });
}

// region helpers

Future<void> _givenIAmOnTheHotelPreCheckoutDialogPageWithBlocState(
  WidgetTester widgetTester,
  HotelPreCheckoutState blocState,
) async {
  final mockBloc = MockHotelPreCheckoutBloc(blocState);
  final subjectWidget = _getSubjectWidget(mockBloc);

  await widgetTester.pumpWidget(subjectWidget);
}

Widget _getSubjectWidget(HotelPreCheckoutBloc hotelPreCheckoutBloc) {
  final mockHotelPreCheckoutModule = MockHotelPreCheckoutModule();
  when(mockHotelPreCheckoutModule.hotelPreCheckoutBloc)
      .thenReturn(hotelPreCheckoutBloc);

  return TestAppFrame(
    child: ModuleProvider<HotelPreCheckoutModule>(
        module: mockHotelPreCheckoutModule,
        child: const HotelPreCheckoutDialog(
            paymentRequestId: TestConstants.stubPartnerMessageId)),
  );
}

// endregion helpers
