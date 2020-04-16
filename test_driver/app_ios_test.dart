import 'package:gherkin/gherkin.dart';

import 'helpers/test_configuration.dart';

Future<void> main() => GherkinRunner().execute(
      getTestConfiguration(
        platform: FlutterDriverTestPlatform.ios,
      ),
    );
