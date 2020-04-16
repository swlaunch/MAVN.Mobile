import 'i_am_logged_in.dart';
import 'i_am_on_the_page.dart';
import 'i_expect_multiline.dart';
import 'is_scrolled_into_view.dart';
import 'service_unavailable.dart';
import 'text_is_not_present.dart';
import 'text_is_present.dart';
import 'widget_is_present.dart';

final List commonSteps = [
  GivenIAmOnThePage(),
  GivenServiceUnavailable(),
  GivenIAmLoggedIn(),
  GivenWidgetIsScrolledIntoView(),
  ThenTextIsPresent(),
  ThenTextIsNotPresent(),
  ThenExpectElementToHaveMultilineValue(),
  GivenWidgetIsScrolledIntoView(),
  ThenWidgetIsPresent(),
];
