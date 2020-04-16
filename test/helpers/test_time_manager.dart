import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';

import '../test_constants.dart';

class TestTimeManager extends DateTimeManager {
  TestTimeManager();

  @override
  DateTime get now => TestConstants.stubDateTime;

  @override
  DateTime toLocal(DateTime time) => time;
}
