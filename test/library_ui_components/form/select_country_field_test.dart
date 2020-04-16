import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_field.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/form_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

WidgetTester _widgetTester;
Router _mockRouter;
Widget _subjectWidget;
FormHelper _formHelper;

void main() {
  group('SelectCountryCodeField tests', () {
    setUp(() {
      _mockRouter = MockRouter();
    });

    testWidgets('SelectCountryCodeField has expected initial text ',
        (widgetTester) async {
      await _givenACountryCodeFieldIsPresent(widgetTester);

      _formHelper.thenTextFieldHasValue(
          key: const Key('fullPageSelectReadOnlyTextField'), value: 'Code');
    });

    testWidgets('SelectCountryCodeField opens SelectCountryCodeListPage',
        (widgetTester) async {
      await _givenACountryCodeFieldIsPresent(widgetTester);
      await _formHelper
          .whenButtonTapped(const Key('fullPageSelectFieldButton'));

      verify(_mockRouter.pushCountryCodePage()).called(1);
    });
  });
}

// region given
Future<void> _givenACountryCodeFieldIsPresent(WidgetTester tester) async {
  _subjectWidget = _getSubjectWidget();
  _formHelper = FormHelper(tester);
  _widgetTester = tester;
  await _widgetTester.pumpWidget(_subjectWidget);
}

// endregion given

// region helpers
Widget _getSubjectWidget() => TestAppFrame(
      mockRouter: _mockRouter,
      child: Scaffold(
        body: FullPageSelectField<CountryCode>(
          key: const Key('countryCodeSelect'),
          inputGlobalKey: GlobalKey<FormFieldState<CountryCode>>(),
          selectedValueNotifier: MockValueNotifier<CountryCode>(),
          routerFn: (mockRouter) => mockRouter.pushCountryCodePage(),
          displayValueSelector: (countryCode) => countryCode.code,
          hint: 'Code',
        ),
      ),
    );

// endregion helpers
