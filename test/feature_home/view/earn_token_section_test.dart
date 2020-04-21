import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_home/view/earn_token_section.dart';
import 'package:lykke_mobile_mavn/library_ui_components/carousel/carousel.dart';
import 'package:lykke_mobile_mavn/library_ui_components/carousel/offer_carousel_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

import '../../helpers/mock_image_http_client.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

Router _mockRouter;

Widget _subjectWidget;
String _stubErrorText = 'error';

void main() {
  group('EarnTokenSection tests', () {
    setUp(() {});

    testWidgets('GenericListUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        earnRuleListState: GenericListUninitializedState(),
      );

      _thenTheLoadingSpinnerShouldNotBeDisplayed();
      _thenTheErrorWidgetShouldNotBeDisplayed();
      _thenTheCarouselShouldNotBeDisplayed();
    });

    testWidgets('GenericListLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        earnRuleListState: GenericListLoadingState(),
      );

      _thenTheLoadingSpinnerShouldBeDisplayed();

      _thenTheErrorWidgetShouldNotBeDisplayed();
      _thenTheCarouselShouldNotBeDisplayed();
    });

    testWidgets('GenericListErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        earnRuleListState: GenericListErrorState(
          error: LocalizedStringBuilder.custom(_stubErrorText),
          currentPage: TestConstants.stubCurrentPage,
          list: [],
        ),
      );

      _thenTheErrorWidgetShouldBeDisplayed();

      _thenTheLoadingSpinnerShouldNotBeDisplayed();
      _thenTheCarouselShouldNotBeDisplayed();
    });

    testWidgets('GenericListLoadedState', (widgetTester) async {
      final earnRules = [
        TestConstants.stubEarnRuleWithStayHotelCondition,
        TestConstants.stubEarnRuleWithStayHotelCondition,
        TestConstants.stubEarnRuleWithStayHotelCondition,
        TestConstants.stubEarnRuleWithStayHotelCondition,
        TestConstants.stubEarnRuleWithStayHotelCondition,
        TestConstants.stubEarnRuleWithStayHotelCondition
      ];
      await provideMockedNetworkImages(() async {
        await _givenSubjectWidgetWithInitialBlocState(
          widgetTester,
          earnRuleListState: GenericListLoadedState(
            list: earnRules,
            totalCount: earnRules.length,
            currentPage: TestConstants.stubCurrentPage,
          ),
        );
      });

      _thenTheCarouselShouldBeDisplayed();
      _thenThereShouldBe5ItemsInTheCarousel();

      _thenTheLoadingSpinnerShouldNotBeDisplayed();
      _thenTheErrorWidgetShouldNotBeDisplayed();
    });
  });
}

// region given
Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  GenericListState earnRuleListState,
}) async {
  _mockRouter = MockRouter();
  _subjectWidget = _getSubjectWidget(earnRuleListState);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}
// endregion given

// region then
void _thenTheLoadingSpinnerShouldBeDisplayed() {
  expect(find.byType(Spinner), findsOneWidget);
}

void _thenTheLoadingSpinnerShouldNotBeDisplayed() {
  expect(find.byType(Spinner), findsNothing);
}

void _thenTheErrorWidgetShouldBeDisplayed() {
  expect(find.byType(GenericErrorWidget), findsOneWidget);
  expect(find.text(_stubErrorText), findsOneWidget);
}

void _thenTheErrorWidgetShouldNotBeDisplayed() {
  expect(find.byType(GenericErrorWidget), findsNothing);
  expect(find.text(_stubErrorText), findsNothing);
}

void _thenTheCarouselShouldBeDisplayed() {
  expect(find.byType(Carousel), findsOneWidget);
}

void _thenThereShouldBe5ItemsInTheCarousel() {
  expect(find.byType(OfferCarouselItem), findsNWidgets(5));
}

void _thenTheCarouselShouldNotBeDisplayed() {
  expect(find.byType(Carousel), findsNothing);
}

// endregion then

// region helpers
Widget _getSubjectWidget(GenericListState earnRuleListState) => TestAppFrame(
      mockRouter: _mockRouter,
      child: Scaffold(
        body: EarnTokenSection(
          theme: LightTheme(),
          earnRuleListState: earnRuleListState,
          onRetryTap: () {},
          router: _mockRouter,
        ),
      ),
    );

// endregion helpers
