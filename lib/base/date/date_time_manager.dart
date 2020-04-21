import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class DateTimeManager {
  DateTimeManager() : _longFormat = DateFormat('d.M.y H:m');

  static const _hoursInADay = 24;

  DateTime get now => DateTime.now();

  final DateFormat _longFormat;

  static final DateFormat _dateFormatCurrentYear = DateFormat('dd MMMM, HH:mm');
  static final DateFormat _dateFormatOtherYear =
      DateFormat('dd MMMM yyyy, HH:mm');

  static final DateFormat _shortDateFormatCurrentYear = DateFormat('MMM dd');
  static final DateFormat _shortDateFormatOtherYear = DateFormat('MMM dd yyyy');

  DateTime toLocal(DateTime time) => time.toLocal();

  String longFormat(DateTime date) => _longFormat.format(date);

  DateFormat getDateFormatBasedOnYear(DateTime date) =>
      now.year == date.year ? _dateFormatCurrentYear : _dateFormatOtherYear;

  DateFormat getShortDateFormatBasedOnYear(DateTime date) =>
      now.year == date.year
          ? _shortDateFormatCurrentYear
          : _shortDateFormatOtherYear;

  String formatBasedOnYear(DateTime date) =>
      getDateFormatBasedOnYear(date).format(date);

  String formatShortBasedOnYear(DateTime date) =>
      getShortDateFormatBasedOnYear(date).format(date);

  ///Calculates how long ago a certain DateTime was and returns relevant string
  ///for example, 1 minute ago, 3 hours ago, 5 days ago
  LocalizedStringBuilder getTimeAgo(DateTime date) {
    final dateDifference = now.difference(date);
    final dateDifferenceInHours = dateDifference.inHours;

    if (dateDifferenceInHours == 0) {
      return LazyLocalizedStrings.minutesAgo(dateDifference.inMinutes);
    }
    if (dateDifferenceInHours < _hoursInADay) {
      return LazyLocalizedStrings.hoursAgo(dateDifferenceInHours);
    }

    return LazyLocalizedStrings.daysAgo(dateDifference.inDays);
  }
}

DateTimeManager useDateTimeManager() =>
    ModuleProvider.of<AppModule>(useContext()).dateTimeManager;
