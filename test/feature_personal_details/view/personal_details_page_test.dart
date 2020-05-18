import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/di/personal_details_module.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/view/personal_details_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

PersonalDetailsBloc _mockPersonalDetailsBloc;

Widget _subjectWidget;
Router _mockRouter;
ExceptionToMessageMapper _mockExceptionToMessage =
    MockExceptionToMessageMapper();

final _localizedStrings = LocalizedStrings();

void main() {
  group('PersonalDetailsPage tests', () {
    setUpAll(() {
      initScreenshots();
    });

    setUp(() {
      _mockPersonalDetailsBloc = null;
    });

    testWidgets('PersonalDetailsUninitializedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          personalDetailsState: PersonalDetailsUninitializedState());

      verify(_mockPersonalDetailsBloc.getCustomerInfo()).called(1);
      expect(find.byKey(const Key('personalDetailsPageSpinner')), findsNothing);
      expect(find.byKey(const Key('personalDetailsError')), findsNothing);
      expect(find.byKey(const Key('personalDetailsView')), findsNothing);
    });

    testWidgets('PersonalDetailsLoadingState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          personalDetailsState: PersonalDetailsLoadingState());

      verify(_mockPersonalDetailsBloc.getCustomerInfo()).called(1);
      expect(
          find.byKey(const Key('personalDetailsPageSpinner')), findsOneWidget);
      expect(find.byKey(const Key('personalDetailsError')), findsNothing);
      expect(find.byKey(const Key('personalDetailsView')), findsNothing);
    });

    testWidgets('PersonalDetailsLoadedState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          personalDetailsState:
              PersonalDetailsLoadedState(customer: TestConstants.stubCustomer));

      verify(_mockPersonalDetailsBloc.getCustomerInfo()).called(1);
      expect(find.byKey(const Key('personalDetailsPageSpinner')), findsNothing);
      expect(find.byKey(const Key('personalDetailsError')), findsNothing);
      expect(find.byKey(const Key('personalDetailsView')), findsOneWidget);

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byType(PersonalDetailsPage),
        'personal_details_page',
      );
    });

    testWidgets('PersonalDetailsGenericErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          personalDetailsState: PersonalDetailsGenericErrorState());

      verify(_mockPersonalDetailsBloc.getCustomerInfo()).called(1);
      expect(find.byKey(const Key('personalDetailsPageSpinner')), findsNothing);
      expect(find.byKey(const Key('personalDetailsError')), findsOneWidget);
      expect(find.byKey(const Key('personalDetailsView')), findsNothing);

      expect(find.text(_localizedStrings.somethingIsNotRightError),
          findsOneWidget);
      expect(find.text(_localizedStrings.personalDetailsGenericError),
          findsOneWidget);
    });

    testWidgets('PersonalDetailsNetworkErrorState', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          personalDetailsState: PersonalDetailsNetworkErrorState());

      verify(_mockPersonalDetailsBloc.getCustomerInfo()).called(1);
      expect(find.byKey(const Key('personalDetailsPageSpinner')), findsNothing);
      expect(find.byKey(const Key('personalDetailsError')), findsNothing);
      expect(find.byKey(const Key('personalDetailsView')), findsNothing);
      expect(find.byKey(const Key('networkError')), findsOneWidget);

      expect(find.text(_localizedStrings.networkErrorTitle), findsOneWidget);
      expect(find.text(_localizedStrings.networkError), findsOneWidget);
    });
  });
}

//////// GIVEN //////////
Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  @required PersonalDetailsState personalDetailsState,
}) async {
  _mockPersonalDetailsBloc = MockPersonalDetailsBloc(personalDetailsState);
  _subjectWidget = _getSubjectWidget(_mockPersonalDetailsBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

//////// HELPERS //////////
Widget _getSubjectWidget(PersonalDetailsBloc personalDetailsBloc) {
  final mockPersonalDetailsModule = MockPersonalDetailsModule();
  when(mockPersonalDetailsModule.personalDetailsBloc)
      .thenReturn(personalDetailsBloc);

  return TestAppFrame(
    mockRouter: _mockRouter,
    mockExceptionToMessageMapper: _mockExceptionToMessage,
    child: ModuleProvider<PersonalDetailsModule>(
        module: mockPersonalDetailsModule, child: PersonalDetailsPage()),
  );
}
