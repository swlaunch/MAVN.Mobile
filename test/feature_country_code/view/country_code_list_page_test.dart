import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_country_code/view/country_code_list_page.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

CountryCodeListBloc _mockCountryCodeListBloc;
Router _mockRouter;

Widget _subjectWidget;

void main() {
  group('CountryCodeListPage tests', () {
    setUp(() {
      _mockRouter = MockRouter();
      _mockCountryCodeListBloc = null;
    });

    testWidgets('CountryCodeListUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListUninitializedState());

      verify(_mockCountryCodeListBloc.loadCountryCodeList()).called(1);
      expect(find.byKey(const Key('fullPageSelectListLoadingSpinner')),
          findsNothing);
      expect(find.byKey(const Key('fullPageSelectList')), findsNothing);
      expect(find.byKey(const Key('fullPageSelectListError')), findsNothing);
    });

    testWidgets('CountryCodeListLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListLoadingState());

      verify(_mockCountryCodeListBloc.loadCountryCodeList()).called(1);
      expect(find.byKey(const Key('fullPageSelectListLoadingSpinner')),
          findsOneWidget);
      expect(find.byKey(const Key('fullPageSelectList')), findsNothing);
      expect(find.byKey(const Key('fullPageSelectListError')), findsNothing);
    });

    testWidgets('CountryCodeListLoadedState empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState:
              CountryCodeListLoadedState(countryCodeList: <CountryCode>[]));

      verify(_mockCountryCodeListBloc.loadCountryCodeList()).called(1);
      expect(find.byKey(const Key('fullPageSelectListLoadingSpinner')),
          findsNothing);
      expect(find.byType(EmptyListWidget), findsOneWidget);
      expect(find.byKey(const Key('fullPageSelectList')), findsNothing);
      expect(find.byKey(const Key('fullPageSelectListError')), findsNothing);
    });

    testWidgets('CountryCodeListLoadedState non-empty state',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListLoadedState(
              countryCodeList: [TestConstants.stubCountryCode]));

      verify(_mockCountryCodeListBloc.loadCountryCodeList()).called(1);
      expect(find.byKey(const Key('fullPageSelectListLoadingSpinner')),
          findsNothing);
      expect(find.byKey(const Key('fullPageSelectList')), findsOneWidget);
      expect(find.byKey(const Key('fullPageSelectListError')), findsNothing);

      expect(find.text(TestConstants.stubCountryName), findsOneWidget);
      expect(find.text(TestConstants.stubValidCountryCodePhoneCode),
          findsOneWidget);
    });

    testWidgets('Pop page after item is selected', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListLoadedState(
              countryCodeList: [TestConstants.stubCountryCode]));

      await widgetTester.tap(find.byType(SelectListItem));
      verify(_mockRouter.pop(TestConstants.stubCountryCode));
    });

    testWidgets('CountryCodeListErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListErrorState(
              LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      verify(_mockCountryCodeListBloc.loadCountryCodeList()).called(1);
      expect(find.byKey(const Key('fullPageSelectListLoadingSpinner')),
          findsNothing);
      expect(find.byKey(const Key('fullPageSelectList')), findsNothing);
      expect(find.byKey(const Key('fullPageSelectListError')), findsOneWidget);

      expect(find.text(TestConstants.stubErrorText), findsOneWidget);
    });

    testWidgets('close button tap', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          countryCodeListState: CountryCodeListUninitializedState());

      await widgetTester.tap(find.byKey(const Key('backButton')));

      verify(_mockRouter.maybePop()).called(1);
    });
  });
}

//////// GIVEN //////////
Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  @required CountryCodeListState countryCodeListState,
}) async {
  _mockCountryCodeListBloc = MockCountryCodeListBloc(countryCodeListState);
  _subjectWidget = _getSubjectWidget(_mockCountryCodeListBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// HELPERS //////////
Widget _getSubjectWidget(CountryCodeListBloc countryCodeListBloc) =>
    TestAppFrame(
      mockRouter: _mockRouter,
      mockCountryCodeListBloc: countryCodeListBloc,
      child: CountryCodeListPage(),
    );
