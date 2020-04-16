import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/di/hotel_welcome_di.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/view/hotel_welcome_dialog.dart';
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

  group('HotelWelcomeDialog tests', () {
    testWidgets('Hotel welcome dialog displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheHotelWelcomeDialogPageWithBlocState(
          widgetTester,
          HotelWelcomeLoadedState(
            partnerName: TestConstants.stubPartnerMessage.partnerName,
            heading: TestConstants.stubPartnerMessage.subject,
            message: TestConstants.stubPartnerMessage.message,
          ));

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byType(HotelWelcomeDialog), 'hotel_welcome_dialog');
    });
  });
}

// region helpers

Future<void> _givenIAmOnTheHotelWelcomeDialogPageWithBlocState(
  WidgetTester widgetTester,
  HotelWelcomeState blocState,
) async {
  final mockBloc = MockHotelWelcomeBloc(blocState);
  final subjectWidget = _getSubjectWidget(mockBloc);

  await widgetTester.pumpWidget(subjectWidget);
}

Widget _getSubjectWidget(HotelWelcomeBloc hotelWelcomeBloc) {
  final mockHotelWelcomeModule = MockHotelWelcomeModule();
  when(mockHotelWelcomeModule.hotelWelcomeBloc).thenReturn(hotelWelcomeBloc);

  return TestAppFrame(
    child: ModuleProvider<HotelWelcomeModule>(
        module: mockHotelWelcomeModule,
        child: const HotelWelcomeDialog(
            partnerMessageId: TestConstants.stubPartnerMessageId)),
  );
}

// endregion helpers
