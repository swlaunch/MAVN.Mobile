import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:meta/meta.dart';

class DateTimeUtils {
  static LocalizedStringBuilder getDescriptiveDate({
    @required DateTime dateTime,
    @required DateFormat dateFormat,
    @required DateTime currentDateTime,
  }) {
    if (DateTimeUtils.isSameDate(dateTime, _todayDateOnly(currentDateTime))) {
      return LazyLocalizedStrings.dateTimeToday;
    }

    if (DateTimeUtils.isSameDate(
        dateTime, _yesterdayDateOnly(currentDateTime))) {
      return LazyLocalizedStrings.dateTimeYesterday;
    }

    return LocalizedStringBuilder.custom(dateFormat.format(dateTime));
  }

  static DateTime _todayDateOnly(DateTime currentDateTime) => DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
      );

  static DateTime _yesterdayDateOnly(DateTime currentDateTime) => DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day - 1,
      );

  static bool isSameDate(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1 == null || dateTime2 == null) return false;
    return dateTime1.day == dateTime2.day &&
        dateTime1.month == dateTime2.month &&
        dateTime1.year == dateTime2.year;
  }

  ///Checks if [from] is within 24 hours of [date]
  static bool dateIsWithin24Hours(DateTime from, DateTime date) =>
      from.difference(date).inHours < 24;
}
