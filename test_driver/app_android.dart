import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/main_automation_android.dart' as app;

import 'helpers/widget_controller_handler.dart';

Future<void> main() async {
  enableFlutterDriverExtension(handler: widgetControllerHandler);

  app.main();
}
