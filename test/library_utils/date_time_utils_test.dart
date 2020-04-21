import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_utils/date_time_utils.dart';

import '../test_constants.dart';

final _localizedStrings = LocalizedStrings();

void main() {
  group('Date time utils tests', () {
    group('get descriptive date', () {
      test("today's date should return the localised text for 'today'", () {
        final stubDateFormat = DateFormat('EEEE, dd MMMM');

        expect(
          DateTimeUtils.getDescriptiveDate(
            dateTime: TestConstants.stubDateTimeToday,
            dateFormat: stubDateFormat,
            currentDateTime: TestConstants.stubDateTime,
          ).from(_localizedStrings),
          _localizedStrings.dateTimeToday,
        );
      });

      test("yesterday's date should return the localised text for 'yesterday'",
          () {
        final stubDateFormat = DateFormat('EEEE, dd MMMM');

        expect(
          DateTimeUtils.getDescriptiveDate(
            dateTime: TestConstants.stubDateTimeYesterday,
            dateFormat: stubDateFormat,
            currentDateTime: TestConstants.stubDateTime,
          ).from(_localizedStrings),
          _localizedStrings.dateTimeYesterday,
        );
      });

      test("yesterday's date should return the localised text for 'yesterday'",
          () {
        final stubDateFormat = DateFormat('EEEE, dd MMMM');

        expect(
          DateTimeUtils.getDescriptiveDate(
            dateTime: DateTime(2019, 6, 22, 14, 22, 10),
            dateFormat: stubDateFormat,
            currentDateTime: TestConstants.stubDateTime,
          ).from(_localizedStrings),
          'Saturday, 22 June',
        );
      });
    });
    group('is same date', () {
      test('should return true if the same date', () {
        expect(
          DateTimeUtils.isSameDate(
              TestConstants.stubDateTime, TestConstants.stubDateTimeToday),
          true,
        );
      });

      test('should return false if different dates', () {
        expect(
          DateTimeUtils.isSameDate(
              TestConstants.stubDateTime, TestConstants.stubDateTimeYesterday),
          false,
        );
      });
    });
  });
}
